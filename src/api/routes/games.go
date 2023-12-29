package routes

import (
	"context"
	"github.com/danielgtaylor/huma/v2"
	"net/http"
	"src/shared/k8sClient"
	"src/shared/valuePtr"
)

type gameInput struct {
	Game string `path:"game" maxLength:"30" example:"game" doc:"Game to start"`
}

func registerStartGameRoute(api huma.API, k8sConfig k8sClient.Config) {
	huma.Register(api, huma.Operation{
		OperationID:   "game.start",
		Summary:       "Start specific game",
		Method:        http.MethodPost,
		Path:          "/games/{game}/start",
		DefaultStatus: 202,
	}, func(ctx context.Context, input *gameInput) (*struct{}, error) {
		err := k8sClient.UpdateGameDataStatus(k8sConfig, input.Game, k8sClient.GameStatus{
			Expected: valuePtr.BoolPtr(true),
		})

		if err != nil {
			return nil, huma.Error404NotFound("Game not supported")
		}

		return nil, nil
	})
}

func registerStopGameRoute(api huma.API, k8sConfig k8sClient.Config) {
	huma.Register(api, huma.Operation{
		OperationID:   "game.start",
		Summary:       "Stop specific game",
		Method:        http.MethodPost,
		Path:          "/games/{game}/stop",
		DefaultStatus: 202,
	}, func(ctx context.Context, input *gameInput) (*struct{}, error) {
		err := k8sClient.UpdateGameDataStatus(k8sConfig, input.Game, k8sClient.GameStatus{
			Expected: valuePtr.BoolPtr(false),
		})

		if err != nil {
			return nil, huma.Error404NotFound("Game not supported")
		}

		return nil, nil
	})
}
