**Skeleton Structure for Integration testing**

```go
func TestMyAppIntegraion(t *testing.T) {
	t.Parallel()
		
	// Set up DB
	dbOpts := createDbOpts(t, myDBDir)
	defer terraform.Destroy(t, dbOpts)
	terraform.InitAndApply(t, dbOpts)

	// Set up App
	appOpts := createHelloOpts(dbOpts, myAppDir)
	defer terraform.Destroy(t, appOpts)
	terraform.InitAndApply(t, appOpts)

	// Validate the App
	validateHelloApp(t, appOpts)
}
```

**Normal Test Process**:
1. Run terraform apply on mysql module
2. Run terraform apply on hello-world module
3. Perform validations
4. Destroy hello-world app module
5. Destroy mysql module

**Recommended Testing Process using Stages**
1. Create infra
2. Perform all testing
3. Delete after testing is completed

> Note:
> - This can be done by using running selective tests as stages using `test_structure` package. You can also stode previous test data locally and fetch later for next tests.
> - You can skip certain tests by setting `SKIP_<test_name>=true` environmental variable.