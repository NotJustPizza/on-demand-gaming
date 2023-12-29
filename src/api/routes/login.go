package routes

import (
	"context"
	"github.com/danielgtaylor/huma/v2"
	"github.com/go-chi/jwtauth/v5"
	"go.uber.org/zap"
	"net/http"
)

type loginInputJson struct {
	Username string `json:"username" maxLength:"32" example:"user" doc:"Username to login as"`
	Password string `json:"password" maxLength:"32" example:"password" doc:"Password to login with"`
}

type loginOutputJson struct {
	Token string `json:"token" example:"eyJhbGciOi..." doc:"JWT token"`
}

type loginOutput struct {
	Body loginOutputJson
}

type loginInput struct {
	Body loginInputJson
}

func registerLoginRoute(api huma.API, tokenAuth *jwtauth.JWTAuth) {
	huma.Register(api, huma.Operation{
		OperationID: "login",
		Summary:     "Login and get JWT token",
		Method:      http.MethodPost,
		Path:        "/login",
	}, func(ctx context.Context, input *loginInput) (*loginOutput, error) {
		var _, tokenString, err = tokenAuth.Encode(
			map[string]interface{}{"user_id": input.Body.Username},
		)
		if err != nil {
			zap.L().Error("Couldn't encode token", zap.Error(err))
			return nil, huma.Error500InternalServerError("Couldn't encode token")
		}

		var resp = &loginOutput{}
		resp.Body.Token = tokenString
		return resp, nil
	})
}
