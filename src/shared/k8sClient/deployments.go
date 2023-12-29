package k8sClient

import (
	"context"
	"go.uber.org/zap"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	appsv1 "k8s.io/client-go/kubernetes/typed/apps/v1"
	"k8s.io/client-go/util/retry"
	"src/shared/valuePtr"
)

func getDeploymentClient(config Config) appsv1.DeploymentInterface {
	return config.Clientset.AppsV1().Deployments(config.Namespace)
}

func ScaleGameDeployment(config Config, game string, enabled bool) error {
	var client = getDeploymentClient(config)

	data, err := GetGameData(config, game)
	if err != nil {
		zap.L().Error(
			"Couldn't scale deployment for game, because couldn't fetch its data",
			zap.Error(err), zap.String("game", game),
		)
		return err
	}

	err = retry.RetryOnConflict(retry.DefaultRetry, func() error {
		result, getErr := client.Get(context.TODO(), data.Deployment.Name, metav1.GetOptions{})
		if getErr != nil {
			zap.L().Warn(
				"Couldn't get deployment from K8s.",
				zap.Error(err), zap.String("deployment", data.Deployment.Name),
			)
			return getErr
		}
		if enabled {
			result.Spec.Replicas = valuePtr.Int32Ptr(1)
		} else {
			result.Spec.Replicas = valuePtr.Int32Ptr(0)
		}
		_, updateErr := client.Update(context.TODO(), result, metav1.UpdateOptions{})
		if updateErr != nil {
			zap.L().Warn(
				"Couldn't update deployment in K8s.",
				zap.Error(err), zap.String("deployment", data.Deployment.Name),
			)
		}
		return updateErr
	})
	if err != nil {
		zap.L().Warn(
			"Couldn't scale deployment in K8s.",
			zap.Error(err), zap.String("deployment", data.Deployment.Name),
		)
	}
	return err
}
