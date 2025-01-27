package test

import (
	"fmt"
	"testing"
	"time"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
)

// Tests must start with prefix "Test"
func TestAlb(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../examples/alb",

		Vars: map[string]interface{}{
			"alb_name": fmt.Sprintf("test-%s", random.UniqueId()), // to handle multiple tests running in parallel
		},
	}

	// Queue the destroy operation to ensure it always runs independent of test result
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	// Test by sending a HTTP request to the ALB endpoint

	// 1. Format the URL with the ALB DNS name
	albDnsName := terraform.Output(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	expectedStatus := 404
	expectedBody := "404: page not found"
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
		nil, // Do not forget
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)

}
