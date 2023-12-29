package main

import (
	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/jwtauth/v5"
	"go.uber.org/zap"
	"net/http"
	"os"
	"src/api/routes"
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
	var appKey = loadEnvVar("APP_KEY")
	var k8sNamespace = loadEnvVar("K8S_NAMESPACE")
	//vultrToken := loadEnvVar("VULTR_TOKEN")

	var tokenAuth = jwtauth.New("HS256", []byte(appKey), nil)
	var k8sConfig = k8sClient.Config{
		Namespace: k8sNamespace,
		Clientset: k8sClient.GetClientset(),
	}

	router := chi.NewMux()
	api := humachi.New(router, huma.DefaultConfig("My API", "1.0.0"))

	RegisterMiddlewares(router, tokenAuth)
	routes.RegisterRoutes(api, tokenAuth, k8sConfig)

	err := http.ListenAndServe(":80", router)

	if err != nil {
		zap.L().Panic("Couldn't start http server", zap.Error(err))
	}
}

func loadEnvVar(name string) string {
	var value, exists = os.LookupEnv(name)
	if !exists {
		zap.L().Fatal("Couldn't load env var", zap.String("env_var", name))
	}
	return value
}
