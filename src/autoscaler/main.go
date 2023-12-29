package autoscaler

import (
	"go.uber.org/zap"
	"os"
	"src/shared/k8sClient"
)

func init() {
	logger := zap.Must(zap.NewDevelopment())
	if os.Getenv("ENVIRONMENT") == "PROD" {
		logger = zap.Must(zap.NewProduction())
	}
	zap.ReplaceGlobals(logger)
}

func main() {
	var k8sNamespace = loadEnvVar("K8S_NAMESPACE")
	var vultrToken = loadEnvVar("VULTR_TOKEN")

	var k8sConfig = k8sClient.Config{
		Namespace: k8sNamespace,
		Clientset: k8sClient.GetClientset(),
	}

	k8sClient.UpdateGameDataStatus()
}

func loadEnvVar(name string) string {
	var value, exists = os.LookupEnv(name)
	if !exists {
		zap.L().Fatal("Couldn't load env var", zap.String("env_var", name))
	}
	return value
}
