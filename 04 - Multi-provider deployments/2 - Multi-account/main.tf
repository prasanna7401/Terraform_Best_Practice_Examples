module "something" {
    source = "./modules/some_example"

    # link root module provider configurations to the child module
    providers = {
        aws.prod = aws.prod_account
        aws.dev = aws.dev_account
    }
    # other configuration
}