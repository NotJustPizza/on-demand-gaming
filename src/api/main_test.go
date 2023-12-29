package main

import (
	"github.com/danielgtaylor/huma/v2/humatest"
	"github.com/go-chi/jwtauth/v5"
	"github.com/stretchr/testify/assert"
	"k8s.io/client-go/kubernetes/fake"
	"net/http"
	"src/api/routes"
	"src/shared/k8sClient"
	"testing"
)

func TestRootOperation(t *testing.T) {
	var tokenAuth = jwtauth.New("HS256", []byte(`testing`), nil)
	var k8sConfig = k8sClient.Config{
		Namespace: "test",
		Clientset: fake.NewSimpleClientset(),
	}

	router, api := humatest.New(t)

	RegisterMiddlewares(router, tokenAuth)
	routes.RegisterRoutes(api, tokenAuth, k8sConfig)

	resp := api.Get("/")
	assert.Equal(t, resp.Code, http.StatusUnauthorized)
}
