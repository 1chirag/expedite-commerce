resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "step_function_role" {
  name = "step-function-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "step_function_permissions" {
  name = "step-function-permissions"
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["lambda:InvokeFunction"],
        Resource = [
          "arn:aws:lambda:us-east-1:679172460726:function:validator_lambda",
          "arn:aws:lambda:us-east-1:679172460726:function:order_storage_lambda"
        ]
      },
      {
        Effect = "Allow",
        Action = ["sqs:SendMessage"],
        Resource = "arn:aws:sqs:us-east-1:679172460726:order_queue"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_dynamodb_write" {
  name = "lambda-dynamodb-write"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:us-east-1:679172460726:table/orders"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_sqs_invoke" {
  name = "lambda-sqs-invoke"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      Resource = "arn:aws:sqs:us-east-1:679172460726:order_queue"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_failed_orders_write" {
  name = "lambda-failed-orders-write"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["dynamodb:PutItem"],
      Resource = "arn:aws:dynamodb:us-east-1:679172460726:table/failed_orders"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_dlq_access" {
  name = "lambda-dlq-access"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      Resource = "arn:aws:sqs:us-east-1:679172460726:order_dlq"
    }]
  })
}