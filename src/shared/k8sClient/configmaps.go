package k8sClient

import (
	"context"
	"encoding/json"
	"go.uber.org/zap"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/util/retry"
)

var gamesConfigMapName = "games"

// GameNode Keep format in sync with Terraform
type GameNode struct {
	Name   string `json:"name"`
	OsID   string `json:"os_id"`
	PlanID string `json:"plan_id"`
}

// GameDeployment  Keep format in sync with Terraform
type GameDeployment struct {
	Name string `json:"name"`
}

// GameStatus Keep format in sync with Terraform
type GameStatus struct {
	Current  *bool `json:"current"`
	Expected *bool `json:"expected"`
}

// GameData Keep format in sync with Terraform
type GameData struct {
	Node       GameNode       `json:"node"`
	Deployment GameDeployment `json:"deployment"`
	Status     GameStatus     `json:"enabled"`
}

func getConfigMapClient(config Config) corev1.ConfigMapInterface {
	return config.Clientset.CoreV1().ConfigMaps(config.Namespace)
}

func GetGameData(config Config, game string) (GameData, error) {
	var data GameData
	var client = getConfigMapClient(config)

	result, err := client.Get(context.TODO(), gamesConfigMapName, metav1.GetOptions{})

	if err != nil {
		zap.L().Error(
			"Couldn't get config map from K8s",
			zap.Error(err), zap.String("config_map", gamesConfigMapName),
		)
		return data, err
	}

	err = json.Unmarshal([]byte(result.Data[game]), &data)

	if err != nil {
		zap.L().Error(
			"Fetched config has invalid format",
			zap.Error(err), zap.String("game", game),
		)
	}

	return data, err
}

func UpdateGameDataStatus(config Config, game string, status GameStatus) error {
	var client = getConfigMapClient(config)

	err := retry.RetryOnConflict(retry.DefaultRetry, func() error {
		var updateData GameData

		getResult, err := client.Get(context.TODO(), gamesConfigMapName, metav1.GetOptions{})
		if err != nil {
			zap.L().Error(
				"Couldn't get config map from K8s",
				zap.Error(err), zap.String("config_map", gamesConfigMapName),
			)
			return err
		}

		err = json.Unmarshal([]byte(getResult.Data[game]), &updateData)
		if err != nil {
			zap.L().Error(
				"Fetched config has invalid format",
				zap.Error(err), zap.String("game", game),
			)
		}

		// Partially update values
		if status.Current != nil {
			updateData.Status.Current = status.Current
		}
		if status.Expected != nil {
			updateData.Status.Expected = status.Expected
		}

		updateDataJson, err := json.Marshal(updateData)
		if err != nil {
			zap.L().Error(
				"Proposed config has invalid format",
				zap.Error(err), zap.String("game", game),
			)
			return err
		}

		getResult.Data[game] = string(updateDataJson)
		getResult.Data["xyz"] = string(updateDataJson)
		//getResult.Data = lo.Assign(getResult.Data, map[string]string{game: string(updateDataJson)})

		_, err = client.Update(context.TODO(), getResult, metav1.UpdateOptions{})
		if err != nil {
			zap.L().Warn(
				"Couldn't update config map in K8s.",
				zap.Error(err), zap.String("config_map", gamesConfigMapName),
			)
		}
		return err
	})
	return err
}
