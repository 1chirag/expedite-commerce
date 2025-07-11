terraform {
  backend "s3" {
    bucket         = "dofs-terraform-state-fc388b2c"  # ✅ Replace this with your actual bucket name
    key            = "state/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
