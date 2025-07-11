provider "aws" {
  region = "us-east-1"
}

module "lambda_iam" {
  source      = "./modules/iam"
  environment = "dev"
}


module "dynamodb" {
  source                   = "./modules/dynamodb"
  orders_table_name        = "orders"
  failed_orders_table_name = "failed_orders"
  environment              = "dev"
}

module "sqs" {
  source      = "./modules/sqs"
  queue_name  = "order_queue"
  dlq_name    = "order_dlq"
  environment = "dev"
}

module "api_handler_lambda" {
  source              = "./modules/lambdas/api_handler"
  lambda_zip_path     = "${path.module}/../artifacts/api_handler.zip"
  lambda_role_arn     = module.lambda_iam.lambda_role_arn     # ✅ from IAM module
  state_machine_arn   = module.step_function.step_function_arn # ✅ from Step Function module
  environment         = "dev"
}


module "step_function" {
  source                    = "./modules/stepfunctions"
  environment               = "dev"
  step_function_role_arn    = module.lambda_iam.step_function_role_arn
  validator_lambda_arn      = module.validator_lambda.lambda_arn
  order_storage_lambda_arn  = module.order_storage_lambda.lambda_arn
  sqs_queue_url             = module.sqs.queue_url
}

module "validator_lambda" {
  source            = "./modules/lambdas/validator"
  lambda_zip_path   = "${path.module}/../artifacts/validator.zip"
  lambda_role_arn   = module.lambda_iam.lambda_role_arn
  environment       = "dev"
}

module "order_storage_lambda" {
  source            = "./modules/lambdas/order_storage"
  lambda_zip_path   = "${path.module}/../artifacts/order_storage.zip"
  lambda_role_arn   = module.lambda_iam.lambda_role_arn
  environment       = "dev"
}

module "fulfill_order_lambda" {
  source           = "./modules/lambdas/fulfill_order"
  lambda_zip_path  = "${path.module}/../artifacts/fulfill_order.zip"
  lambda_role_arn  = module.lambda_iam.lambda_role_arn
  environment      = "dev"
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = module.sqs.queue_arn  # Output from SQS module
  function_name = module.fulfill_order_lambda.function_name
  batch_size       = 1
  enabled          = true
}

module "dlq_handler_lambda" {
  source           = "./modules/lambdas/dlq_handler"
  lambda_role_arn  = module.lambda_iam.lambda_role_arn
  lambda_zip_path  = "${path.module}/../artifacts/dlq_handler.zip"
  environment      = "dev"
  dlq_arn          = module.sqs.dlq_arn
}