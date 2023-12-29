package routes

import (
	"fmt"
	"github.com/danielgtaylor/huma/v2/humatest"
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"net/http"
	"src/shared/k8sClient"
	"testing"
)

func TestGameStartRoute(t *testing.T) {
	var k8sConfig = k8sClient.Config{
		Namespace: "test",
		Clientset: fake.NewSimpleClientset(),
	}

	_, api := humatest.New(t)

	k8sClient.FixtureGamesConfigMap(t, k8sConfig, []k8sClient.FixtureGame{
		{"test", "test_deployment", "test_node"},
	})
	registerStartGameRoute(api, k8sConfig)

	var resp = api.Post(fmt.Sprintf("/games/%s/start", "test"))
	assert.Equal(t, resp.Code, http.StatusAccepted)
}

func TestGameStopRoute(t *testing.T) {
	var k8sConfig = k8sClient.Config{
		Namespace: "test",
		Clientset: fake.NewSimpleClientset(),
	}

	_, api := humatest.New(t)

	k8sClient.FixtureGamesConfigMap(t, k8sConfig, []k8sClient.FixtureGame{
		{"test", "test_deployment", "test_node"},
	})
	registerStopGameRoute(api, k8sConfig)

	var resp = api.Post(fmt.Sprintf("/games/%s/stop", "test"))
	assert.Equal(t, resp.Code, http.StatusAccepted)
}
