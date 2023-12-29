package k8sClient

import (
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"src/shared/valuePtr"
	"testing"
)

func TestUpdateGameData(t *testing.T) {
	var config = Config{
		"test",
		fake.NewSimpleClientset(),
	}

	FixtureGamesConfigMap(t, config, []FixtureGame{
		{"test", "test_deployment", "test_node"},
	})

	err := UpdateGameDataStatus(config, "test", GameStatus{Current: valuePtr.BoolPtr(true)})
	assert.NoError(t, err)
}
