package routes

import (
	"github.com/danielgtaylor/huma/v2/humatest"
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"net/http"
	"src/shared/k8sClient"
	"testing"
)

func TestScalingEnableRoute(t *testing.T) {
	var k8sConfig = k8sClient.Config{
		Namespace: "test",
		Clientset: fake.NewSimpleClientset(),
	}

	_, api := humatest.New(t)

	k8sClient.FixtureScalingStatusConfigMap(t, k8sConfig)
	registerEnableScalingRoute(api, k8sConfig)

	var resp = api.Post("/scaling/enable")
	assert.Equal(t, resp.Code, http.StatusAccepted)
}

func TestScalingDisableRoute(t *testing.T) {
	var k8sConfig = k8sClient.Config{
		Namespace: "test",
		Clientset: fake.NewSimpleClientset(),
	}

	_, api := humatest.New(t)

	k8sClient.FixtureScalingStatusConfigMap(t, k8sConfig)
	registerDisableScalingRoute(api, k8sConfig)

	var resp = api.Post("/scaling/disable")
	assert.Equal(t, resp.Code, http.StatusAccepted)
}
