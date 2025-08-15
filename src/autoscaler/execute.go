package main

import (
	"go.uber.org/zap"
	"src/shared/k8sClient"
	"src/shared/valuePtr"
)

func executeAutoscaling(k8sConfig k8sClient.Config) error {
	var replicas int32

	data, err := k8sClient.GetScalingStatusConfigMap(k8sConfig)
	if err != nil {
		zap.L().Error("Couldn't get scaling status config map")
		return err
	}

	if data.Expected == k8sClient.ENABLED {
		replicas = 1
	} else if data.Expected == k8sClient.DISABLED {
		replicas = 0
	} else {
		zap.L().Error(
			"Unsupported expected status",
			zap.Error(err), zap.String("expected", data.Expected),
		)
		return err
	}

	err = k8sClient.ScaleAvorionDeployment(k8sConfig, replicas)
	if err != nil {
		zap.L().Error(
			"Couldn't scale avorion deployment",
			zap.Error(err), zap.Int32("replicas", replicas),
		)
		return err
	}

	err = k8sClient.UpdateScalingStatusConfigMap(k8sConfig, k8sClient.ScalingStatusOptional{
		Current: valuePtr.StringPtr(data.Expected),
	})
	if err != nil {
		zap.L().Error(
			"Couldn't update status config map",
			zap.Error(err), zap.String("current", data.Expected),
		)
	}

	return err
}
