package k8sClient

import (
	"go.uber.org/zap"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

type Config struct {
	Namespace string
	Clientset kubernetes.Interface
}

func GetClientset() kubernetes.Interface {
	config, err := rest.InClusterConfig()
	if err != nil {
		zap.L().Fatal("Couldn't get cluster config for K8s client", zap.Error(err))
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		zap.L().Fatal("Couldn't create new clientset for K8s client", zap.Error(err))
	}
	return clientset
}
