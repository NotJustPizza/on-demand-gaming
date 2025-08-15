package main

import (
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"src/shared/k8sClient"
	"testing"
)

func TestExecuteAutoscaling(t *testing.T) {
	var k8sConfig = k8sClient.Config{
		Namespace: "test",
		Clientset: fake.NewSimpleClientset(),
	}
	k8sClient.FixtureAvorionDeployment(t, k8sConfig)
	k8sClient.FixtureScalingStatusConfigMap(t, k8sConfig)

	err := executeAutoscaling(k8sConfig)
	assert.NoError(t, err)
}
