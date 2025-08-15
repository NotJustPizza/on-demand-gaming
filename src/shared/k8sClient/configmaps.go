package k8sClient

import (
	"context"
	"github.com/mitchellh/mapstructure"
	"go.uber.org/zap"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	corev1 "k8s.io/client-go/kubernetes/typed/core/v1"
	"k8s.io/client-go/util/retry"
)

const (
	scalingStatusExpected = "expected"
)

// Keep them in sync with Kustomize
var scalingStatusConfigMapName = "scaling-status"
var nodeConfigMapName = "tf-node"

type Node struct {
	Name   string `json:"name"`
	OsID   string `json:"os_id"`
	PlanID string `json:"plan_id"`
}

type ScalingStatus struct {
	Current  string `json:"current"`
	Expected string `json:"expected"`
}

type ScalingStatusOptional struct {
	Current  *string `json:"current"`
	Expected *string `json:"expected"`
}

func getConfigMapClient(config Config) corev1.ConfigMapInterface {
	return config.Clientset.CoreV1().ConfigMaps(config.Namespace)
}

func getConfigMapData(config Config, configMapName string, configMapData any) error {
	var client = getConfigMapClient(config)

	result, err := client.Get(context.TODO(), configMapName, metav1.GetOptions{})

	if err != nil {
		zap.L().Error(
			"Couldn't get config map from K8s",
			zap.Error(err), zap.String("config_map", configMapName),
		)
		return err
	}

	err = mapstructure.Decode(result.Data, &configMapData)

	if err != nil {
		zap.L().Error(
			"Fetched config has invalid format",
			zap.Error(err), zap.String("config_map", configMapName),
		)
	}

	return err
}

func GetNodeConfigMap(config Config) (Node, error) {
	var data Node
	err := getConfigMapData(config, nodeConfigMapName, data)
	return data, err
}

func GetScalingStatusConfigMap(config Config) (ScalingStatus, error) {
	var data ScalingStatus
	err := getConfigMapData(config, scalingStatusConfigMapName, data)
	return data, err
}

func UpdateScalingStatusConfigMap(config Config, data ScalingStatusOptional) error {
	var client = getConfigMapClient(config)

	err := retry.RetryOnConflict(retry.DefaultRetry, func() error {
		var updateData ScalingStatus

		getResult, err := client.Get(context.TODO(), scalingStatusConfigMapName, metav1.GetOptions{})
		if err != nil {
			zap.L().Error(
				"Couldn't get config map from K8s",
				zap.Error(err), zap.String("config_map", scalingStatusConfigMapName),
			)
			return err
		}

		err = mapstructure.Decode(getResult.Data, &updateData)
		if err != nil {
			zap.L().Error(
				"Fetched config has invalid format",
				zap.Error(err), zap.String("config_map", scalingStatusConfigMapName),
			)
		}

		// Partially update values
		if data.Current != nil {
			updateData.Current = *data.Current
		}
		if data.Expected != nil {
			updateData.Expected = *data.Expected
		}

		err = mapstructure.Decode(updateData, &getResult.Data)
		if err != nil {
			zap.L().Error(
				"Proposed config has invalid format",
				zap.Error(err), zap.String("config_map", scalingStatusConfigMapName),
			)
			return err
		}

		_, err = client.Update(context.TODO(), getResult, metav1.UpdateOptions{})
		if err != nil {
			zap.L().Warn(
				"Couldn't update config map in K8s.",
				zap.Error(err), zap.String("config_map", scalingStatusConfigMapName),
			)
		}
		return err
	})
	return err
}
