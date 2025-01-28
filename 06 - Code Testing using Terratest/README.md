**Instructions**:
1. Install go.
2. Run `go mod init <NAME>`, where _NAME_ is the name you want for the test suite.
3. After the code is ready, run `go test -v`.
4. Run `go mod tidy` to remove unused dependencies and refresh new dependencies.
5. Setup `-timeout 30m` when running `go test` to ensure that your code runs beyond the default 10m timeout to handle infrastructure deployments.
6. You can run a specific testing using `go test -v -run <TEST_NAME>`.

**Note**: 
1. The no. of tests run will be equal to the no. of CPUS in the computer. You can override this by setting `GOMAXPROCS` environment variable, or by setting `-parallel <no_of_runs>` argument.
2. Avoid running multiple test runs without having multiple directory structure, because the parallel runs could overwrite eachother's _.terraform_ folder.
