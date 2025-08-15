package routes

import (
	"github.com/danielgtaylor/huma/v2"
	"github.com/go-chi/jwtauth/v5"
	"src/shared/k8sClient"
)

func RegisterRoutes(api huma.API, tokenAuth *jwtauth.JWTAuth, k8sConfig k8sClient.Config) {
	registerLoginRoute(api, tokenAuth)
	registerEnableScalingRoute(api, k8sConfig)
	registerDisableScalingRoute(api, k8sConfig)
}
