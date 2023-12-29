package k8sClient

import (
	"context"
	"fmt"
	"github.com/stretchr/testify/assert"
	appsv1 "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"src/shared/valuePtr"
	"testing"
)

type FixtureGame struct {
	Name           string
	DeploymentName string
	NodeName       string
}

func FixtureGameDeployment(t *testing.T, config Config, name string) {
	var deploymentsClient = config.Clientset.AppsV1().Deployments(config.Namespace)

	deployment := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name: name,
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: valuePtr.Int32Ptr(0),
		},
	}

	_, err := deploymentsClient.Create(context.TODO(), deployment, metav1.CreateOptions{})
	assert.NoError(t, err)
}

func FixtureGamesConfigMap(t *testing.T, config Config, games []FixtureGame) {
	var configsClient = config.Clientset.CoreV1().ConfigMaps(config.Namespace)
	var data = make(map[string]string)
	var game FixtureGame

	for _, game = range games {
		data[game.Name] = fmt.Sprintf(
			"{\"deployment\":{\"name\":\"%s\"},\"status\":{\"current\":false,\"expected\":false},\"node\":{\"name\":\"%s\",\"plan_id\":\"vhf-1c-2gb\"}}",
			game.DeploymentName, game.NodeName)
	}

	configMap := &v1.ConfigMap{
		ObjectMeta: metav1.ObjectMeta{Name: gamesConfigMapName},
		Data:       data,
	}

	_, err := configsClient.Create(context.TODO(), configMap, metav1.CreateOptions{})
	assert.NoError(t, err)
}
