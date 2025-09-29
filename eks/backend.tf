# terraform {
#   backend "s3" {
#     bucket         = "bucket-for-state"
#     key            = "eks/terraform.tfstate"
#     encrypt        = true
#     dynamodb_table = "lock-tf-eks"
#   }
# }
