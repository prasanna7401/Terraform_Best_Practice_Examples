module "my-k8s-app" {
  source = "../modules/k8s-app"

  name          = "my-k8s-app"
  image         = "hello-world"
  container_port = 80
  local_port    = 8080
  replicas      = 2
  env_vars = {
    PROVIDER = "Prasanna" # so that, the app prints "Hello, ${PROVIDER}"
  }
}