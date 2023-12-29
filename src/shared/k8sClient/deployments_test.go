package k8sClient

import (
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"testing"
)

func TestScaleDeployment(t *testing.T) {
	var config = Config{
		"test",
		fake.NewSimpleClientset(),
	}

	FixtureGameDeployment(t, config, "test_deployment")
	FixtureGamesConfigMap(t, config, []FixtureGame{
		{"test", "test_deployment", "test_node"},
	})

	err := ScaleGameDeployment(config, "test", true)
	assert.NoError(t, err)
}
