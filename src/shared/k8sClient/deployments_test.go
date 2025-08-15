package k8sClient

import (
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"testing"
)

func TestScaleAvorionDeployment(t *testing.T) {
	var config = Config{
		"test",
		fake.NewSimpleClientset(),
	}

	FixtureAvorionDeployment(t, config)

	err := ScaleAvorionDeployment(config, 1)
	assert.NoError(t, err)
}
