package routes

import (
	"bytes"
	"encoding/json"
	"github.com/danielgtaylor/huma/v2/humatest"
	"github.com/go-chi/jwtauth/v5"
	"github.com/stretchr/testify/assert"
	"net/http"
	"strings"
	"testing"
)

func TestLoginRoute(t *testing.T) {
	var tokenAuth = jwtauth.New("HS256", []byte(`testing`), nil)
	var _, api = humatest.New(t)

	registerLoginRoute(api, tokenAuth)

	var resp = api.Post("/login", bytes.NewReader(
		[]byte(`{"username": "user", "password": "password"}`),
	))
	assert.Equal(t, resp.Code, http.StatusOK)

	var loginJson loginOutputJson
	err := json.Unmarshal([]byte(resp.Body.String()), &loginJson)
	assert.NoError(t, err)
	assert.True(t, strings.HasPrefix(loginJson.Token, "ey"))
}
