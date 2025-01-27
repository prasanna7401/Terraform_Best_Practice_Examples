locals {
  status = kubernetes_service.my-app.status
}

output "service_endpoint" {
  value = try("http://${local.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}","ERROR parsing hostname from k8s service status")
  description = "K8s endpoint info"
}

# We parse a data that looks something like this:
# [
#   {
#     "load_balancer": [
#       {
#         "ingress": [
#           {
#             "hostname": "abcdefg12345.us-west-2.elb.amazonaws.com"
#           }
#         ]
#       }
#     ]
#   }
# ]

# hostname is buried in the data structure, so we use try() to handle the error if the data structure is not as expected. 
# So, the value returns the first data that doesn't throw an error.