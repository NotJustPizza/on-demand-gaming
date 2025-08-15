package k8sClient

import (
	"context"
	"github.com/stretchr/testify/assert"
	appsv1 "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"src/shared/valuePtr"
	"testing"
)

func fixtureConfigMap(t *testing.T, config Config, name string, data map[string]string) {
	var configsClient = config.Clientset.CoreV1().ConfigMaps(config.Namespace)

	configMap := &v1.ConfigMap{
		ObjectMeta: metav1.ObjectMeta{Name: name},
		Data:       data,
	}

	_, err := configsClient.Create(context.TODO(), configMap, metav1.CreateOptions{})
	assert.NoError(t, err)
}

func FixtureNodeConfigMap(t *testing.T, config Config) {
	var data = make(map[string]string)
	data["os_id"] = "1000"
	data["plan_id"] = "vhf-1c-2gb"
	data["region"] = "waw"
	fixtureConfigMap(t, config, nodeConfigMapName, data)
}

func FixtureScalingStatusConfigMap(t *testing.T, config Config) {
	var data = make(map[string]string)
	data["expected"] = ENABLED
	data["current"] = DISABLED
	fixtureConfigMap(t, config, scalingStatusConfigMapName, data)
}

func FixtureAvorionDeployment(t *testing.T, config Config) {
	var deploymentsClient = config.Clientset.AppsV1().Deployments(config.Namespace)

	deployment := &appsv1.Deployment{
		ObjectMeta: metav1.ObjectMeta{
			Name: avorionDeploymentName,
		},
		Spec: appsv1.DeploymentSpec{
			Replicas: valuePtr.Int32Ptr(0),
		},
	}

	_, err := deploymentsClient.Create(context.TODO(), deployment, metav1.CreateOptions{})
	assert.NoError(t, err)
}
