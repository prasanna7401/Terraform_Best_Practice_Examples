package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"strings"
	"testing"
	"time"
)

const dbDirProd = "../live/prod/data-stores/mysql"
const appDirProd = "../live/prod/services/hello-world-app"

// Replace these with the proper paths to your modules
const dbDirStage = "../live/stage/data-stores/mysql"
const appDirStage = "../live/stage/services/hello-world-app"

func TestHelloWorldAppStage(t *testing.T) {
	t.Parallel()

	// Deploy the MySQL DB
	dbOpts := createDbOpts(t, dbDirStage)
	defer terraform.Destroy(t, dbOpts)
	terraform.InitAndApply(t, dbOpts)

	// Deploy the hello-world-app
	helloOpts := createHelloOpts(dbOpts, appDirStage)
	defer terraform.Destroy(t, helloOpts)
	terraform.InitAndApply(t, helloOpts)

	// Validate the hello-world-app works
	validateHelloApp(t, helloOpts)
}

func createDbOpts(t *testing.T, terraformDir string) *terraform.Options {
	uniqueId := random.UniqueId()

	bucketForTesting := GetRequiredEnvVar(t, TerraformStateBucketForTestEnvVarName)
	bucketRegionForTesting := GetRequiredEnvVar(t, TerraformStateRegionForTestEnvVarName)

	dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), uniqueId)

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{}{
			"db_name":     fmt.Sprintf("test%s", uniqueId),
			"db_username": "admin",
			"db_password": "password",
		},

		BackendConfig: map[string]interface{}{
			"bucket":  bucketForTesting,
			"region":  bucketRegionForTesting,
			"key":     dbStateKey,
			"encrypt": true,
		},
	}
}

func createHelloOpts(
	dbOpts *terraform.Options,
	terraformDir string) *terraform.Options {

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]interface{}{
			"db_remote_state_bucket": dbOpts.BackendConfig["bucket"],
			"db_remote_state_key":    dbOpts.BackendConfig["key"],
			"environment":            dbOpts.Vars["db_name"],
		},

		// Retry up to 3 times, with 5 seconds between retries,
		// on known errors - To avoid flaky test failures
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Throttling issue?",
		},
	}
}

func validateHelloApp(t *testing.T, helloOpts *terraform.Options) {
	albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, "Hello, World")
		},
	)
}

// DEPLOYMENT AS STAGES - ANOTHER TYPE OF TEST ORGANIZATION

func TestHelloWorldAppStageWithStages(t *testing.T) {
	t.Parallel()

	// Store the function in a short variable name solely to make the
	// code examples fit better in the book.
	stage := test_structure.RunTestStage

	// The RunTestStage take 3 arguments: t, stage_name, and the block to execute

	// Deploy the MySQL DB
	defer stage(t, "teardown_db", func() { teardownDb(t, dbDirStage) })
	stage(t, "deploy_db", func() { deployDb(t, dbDirStage) })

	// Deploy the hello-world-app
	defer stage(t, "teardown_app", func() { teardownApp(t, appDirStage) })
	stage(t, "deploy_app", func() { deployApp(t, dbDirStage, appDirStage) })

	// Validate the hello-world-app works
	stage(t, "validate_app", func() { validateApp(t, appDirStage) })
}

func teardownDb(t *testing.T, dbDir string) {
	dbOpts := test_structure.LoadTerraformOptions(t, dbDir) // Loads test data from disk
	defer terraform.Destroy(t, dbOpts)
}

func deployDb(t *testing.T, dbDir string) {
	dbOpts := createDbOpts(t, dbDir)

	// Save data to disk so that other test stages executed at a later
	// time can read the data back in
	test_structure.SaveTerraformOptions(t, dbDir, dbOpts) // Saves test data to disk

	terraform.InitAndApply(t, dbOpts)
}

func teardownApp(t *testing.T, helloAppDir string) {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
	defer terraform.Destroy(t, helloOpts)
}

func deployApp(t *testing.T, dbDir string, helloAppDir string) {
	dbOpts := test_structure.LoadTerraformOptions(t, dbDir)
	helloOpts := createHelloOpts(dbOpts, helloAppDir)

	// Save data to disk so that other test stages executed at a later
	// time can read the data back in
	test_structure.SaveTerraformOptions(t, helloAppDir, helloOpts)

	terraform.InitAndApply(t, helloOpts)
}

func validateApp(t *testing.T, helloAppDir string) {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
	validateHelloApp(t, helloOpts)
}

func TestHelloWorldAppProdWithStages(t *testing.T) {
	t.Parallel()

	// Deploy the MySQL DB
	defer test_structure.RunTestStage(t, "teardown_db", func() { teardownDb(t, dbDirProd) })
	test_structure.RunTestStage(t, "deploy_db", func() { deployDb(t, dbDirProd) })

	// Deploy the hello-world-app
	defer test_structure.RunTestStage(t, "teardown_app", func() { teardownApp(t, appDirProd) })
	test_structure.RunTestStage(t, "deploy_app", func() { deployApp(t, dbDirProd, appDirProd) })

	// Validate the hello-world-app works
	test_structure.RunTestStage(t, "validate_app", func() { validateApp(t, appDirProd) })
}
