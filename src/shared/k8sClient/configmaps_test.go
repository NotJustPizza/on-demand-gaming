package k8sClient

import (
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"src/shared/valuePtr"
	"testing"
)

func TestGetNodeConfigMap(t *testing.T) {
	var config = Config{
		"test",
		fake.NewSimpleClientset(),
	}

	FixtureNodeConfigMap(t, config)

	_, err := GetNodeConfigMap(config)
	assert.NoError(t, err)
}

func TestGetScalingStatusConfigMap(t *testing.T) {
	var config = Config{
		"test",
		fake.NewSimpleClientset(),
	}

	FixtureScalingStatusConfigMap(t, config)

	_, err := GetScalingStatusConfigMap(config)
	assert.NoError(t, err)
}

func TestUpdateScalingStatusMap(t *testing.T) {
	var config = Config{
		"test",
		fake.NewSimpleClientset(),
	}

	FixtureScalingStatusConfigMap(t, config)

	err := UpdateScalingStatusConfigMap(config, ScalingStatusOptional{Current: valuePtr.StringPtr(ENABLED)})
	assert.NoError(t, err)
}
