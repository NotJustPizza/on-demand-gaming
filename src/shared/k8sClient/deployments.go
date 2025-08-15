package k8sClient

import (
	"context"
	"go.uber.org/zap"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	appsv1 "k8s.io/client-go/kubernetes/typed/apps/v1"
	"k8s.io/client-go/util/retry"
)

var avorionDeploymentName = "avorion"

func getDeploymentClient(config Config) appsv1.DeploymentInterface {
	return config.Clientset.AppsV1().Deployments(config.Namespace)
}

func ScaleAvorionDeployment(config Config, replicas int32) error {
	var client = getDeploymentClient(config)

	finalErr := retry.RetryOnConflict(retry.DefaultRetry, func() error {
		result, err := client.Get(context.TODO(), avorionDeploymentName, metav1.GetOptions{})
		if err != nil {
			zap.L().Warn(
				"Couldn't get deployment from K8s.",
				zap.Error(err), zap.String("deployment", avorionDeploymentName),
			)
			return err
		}

		result.Spec.Replicas = &replicas

		_, err = client.Update(context.TODO(), result, metav1.UpdateOptions{})
		if err != nil {
			zap.L().Warn(
				"Couldn't update deployment in K8s.",
				zap.Error(err), zap.String("deployment", avorionDeploymentName),
			)
		}
		return err
	})
	if finalErr != nil {
		zap.L().Warn(
			"Couldn't scale deployment in K8s.",
			zap.Error(finalErr), zap.String("deployment", avorionDeploymentName),
		)
	}
	return finalErr
}
