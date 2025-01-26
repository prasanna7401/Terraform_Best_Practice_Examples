# Code Source - https://github.com/hashicorp/terraform-sentinel-policies/blob/main/aws/sentinel.hcl

policy "restrict-ec2-instance-type" {
  source = "./restrict-ec2-instance-type.sentinel"
  enforcement_level = "hard-mandatory" # advisory, soft-mandatory, hard-mandatory
}
