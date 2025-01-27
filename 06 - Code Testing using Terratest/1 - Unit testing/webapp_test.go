package test

import (
	"fmt"
	"testing"
	"time"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	//"github.com/stretchr/testify/require"
)

func TestMyApp(t *testing.T) {

	t.Parallel() // Run tests in parallel

	opts := &terraform.Options{
		TerraformDir: "../examples/hello-world-app/standalone",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"mysql_config": map[string]interface{}{
				"address": "some_address",
				"port":    3306,
			},

			"environment": fmt.Sprintf("test-%s", random.UniqueId()), // to handle multiple tests running in parallel

		},
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && body == "Hello, World!"
		},
	)
}
