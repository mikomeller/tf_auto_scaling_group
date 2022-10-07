terraform {
  backend "s3" {
    bucket = "talent-academy-terraform-tfstates-787786425565"
    key    = "project/load_balancers/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}