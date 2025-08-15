package routes

import (
	"context"
	"github.com/danielgtaylor/huma/v2"
	"go.uber.org/zap"
	"net/http"
	"src/shared/k8sClient"
	"src/shared/valuePtr"
)

func registerEnableScalingRoute(api huma.API, k8sConfig k8sClient.Config) {
	huma.Register(api, huma.Operation{
		OperationID:   "scaling.enable",
		Summary:       "Enable scaling",
		Method:        http.MethodPost,
		Path:          "/scaling/enable",
		DefaultStatus: 202,
	}, func(ctx context.Context, input *struct{}) (*struct{}, error) {
		err := k8sClient.UpdateScalingStatusConfigMap(k8sConfig, k8sClient.ScalingStatusOptional{
			Expected: valuePtr.StringPtr(k8sClient.ENABLED),
		})

		if err != nil {
			zap.L().Error("Server error occurred", zap.Error(err))
			return nil, huma.Error500InternalServerError("Server error occurred")
		}

		return nil, nil
	})
}

func registerDisableScalingRoute(api huma.API, k8sConfig k8sClient.Config) {
	huma.Register(api, huma.Operation{
		OperationID:   "scaling.disable",
		Summary:       "Disable scaling",
		Method:        http.MethodPost,
		Path:          "/scaling/disable",
		DefaultStatus: 202,
	}, func(ctx context.Context, input *struct{}) (*struct{}, error) {
		err := k8sClient.UpdateScalingStatusConfigMap(k8sConfig, k8sClient.ScalingStatusOptional{
			Expected: valuePtr.StringPtr(k8sClient.DISABLED),
		})

		if err != nil {
			zap.L().Error("Server error occurred", zap.Error(err))
			return nil, huma.Error500InternalServerError("Server error occurred")
		}

		return nil, nil
	})
}
