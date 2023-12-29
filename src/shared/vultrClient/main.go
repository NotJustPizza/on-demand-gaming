package vultrClient

import (
	"encoding/json"
	"fmt"
	"github.com/go-resty/resty/v2"
	"go.uber.org/zap"
)

type CreateInstanceData struct {
	Region   string `json:"region"`
	Plan     string `json:"plan"`
	Label    string `json:"label"`
	OSID     int    `json:"os_id"`
	UserData string `json:"user_data"`
	Hostname string `json:"hostname"`
}

type InstanceData struct {
	ID       int    `json:"id"`
	Region   string `json:"region"`
	Plan     string `json:"plan"`
	Label    string `json:"label"`
	OSID     int    `json:"os_id"`
	Hostname string `json:"hostname"`
}

var baseURL = "https://api.vultr.com"

func getRestyClient(token string) *resty.Client {
	var client = resty.New()

	client.SetHeader("Accept", "application/json")
	client.SetHeader("Content-Type", "application/json")
	client.SetAuthToken(token)

	return client
}

func CreateInstance(token string, instance CreateInstanceData) (*InstanceData, error) {
	var client = getRestyClient(token)

	data, err := json.Marshal(instance)
	if err != nil {
		zap.L().Error(
			"Provided instance cannot be parsed to json",
			zap.Error(err), zap.Any("instance", instance),
		)
	}

	resp, err := client.R().
		SetBody(data).
		SetResult(InstanceData{}).
		Post(fmt.Sprintf("%s/v2/instances", baseURL))

	if err != nil {
		zap.L().Error(
			"Couldn't create instance using Vultr API",
			zap.Error(err), zap.Any("instance", instance),
		)
	}

	return resp.Result().(*InstanceData), err
}

func GetInstance(token string, id string) (*InstanceData, error) {
	var client = getRestyClient(token)

	resp, err := client.R().
		SetResult(InstanceData{}).
		Get(fmt.Sprintf("%s/v2/instances/%s", baseURL, id))

	if err != nil {
		zap.L().Error(
			"Couldn't get instance using Vultr API",
			zap.Error(err), zap.Any("instance_id", id),
		)
	}

	return resp.Result().(*InstanceData), err
}

func main() {
}
