🚀 Serverless Order Fulfillment System (DOFS)
This project builds a serverless, event-driven architecture using AWS + Terraform + Python to handle order processing, validation, fulfillment, and failure handling.
It is fully automated with CI/CD via AWS CodePipeline.

-----------------------------

📚 Table of Contents
📖 Project Overview
🧰 Prerequisites
🛠️ Tech Stack
🧱 System Architecture
🚧 Infrastructure Setup (Terraform)
📦 CI/CD Pipeline Setup (CodePipeline)
✅ Testing the Flow
📌 Optional Enhancements

-----------------------------

📖 Project Overview
The system provides:
A REST API to receive orders
A Step Function to orchestrate the flow
Lambdas for validation, storage, fulfillment, and DLQ handling
SQS queue and DLQ for decoupling and fault tolerance
DynamoDB tables for tracking orders and failed records
Terraform-based infrastructure automation
AWS CodePipeline for CI/CD automation

-----------------------------

🧰 Prerequisites
Before starting, ensure the following are installed on your machine:

Tool	Version	Purpose
AWS CLI	v2+	To authenticate with AWS
Terraform	v1.5+	Infrastructure as Code (IaC)
Python	3.9+	For writing Lambda functions
Git	Any	Version control
Visual Studio Code	Any	Code editor
AWS Account	Required	To provision all resources
GitHub Repo	Required	For hosting Terraform and code

-----------------------------

🛠️ Tech Stack
AWS Lambda – Event-driven compute
AWS Step Functions – Orchestration logic
AWS API Gateway – REST endpoint
AWS SQS + DLQ – Asynchronous messaging
AWS DynamoDB – Order storage (NoSQL)
AWS CodePipeline – CI/CD automation
Terraform – Infrastructure as Code
Python – Lambda implementation
GitHub – Source code hosting

-----------------------------

🧱 System Architecture

Client (Postman, curl, etc.)
        |
   [API Gateway]
        |
   [api_handler Lambda]
        |
   [Step Function]
     |     |     |
     ↓     ↓     ↓
Validate Store SendToQueue
 Lambda  Lambda    to SQS
                    ↓
               [order_queue]
                    ↓
             [fulfill_order Lambda]
                    ↓
       Update status → DynamoDB
                    ↓
       Failed after retries → DLQ
                    ↓
          [dlq_handler Lambda]
                    ↓
       Save to → failed_orders table

-----------------------------

📁 Folder Structure

expedite-commerce/
│
├── lambda/                      # Raw Python code (before zip)
│   ├── api_handler/
│   │   └── main.py
│   ├── validator/
│   │   └── main.py
│   ├── order_storage/
│   │   └── main.py
│   ├── fulfill_order/
│   │   └── main.py
│   └── dlq_handler/
│       └── main.py
│
├── artifacts/                   # Zipped Lambda packages (used in deployment)
│   ├── api_handler.zip
│   ├── validator.zip
│   ├── order_storage.zip
│   ├── fulfill_order.zip
│   └── dlq_handler.zip
│
├── modules/
│   ├── lambdas/
│   │   ├── api_handler/
│   │   ├── validator/
│   │   ├── order_storage/
│   │   ├── fulfill_order/
│   │   └── dlq_handler/
│   ├── sqs/
│   ├── stepfunction/
│   ├── dynamodb/
│   └── pipeline/
│   ├── iam/

├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│
├── buildspec.yml                # CodeBuild instructions
├── README.md                    # Documentation

-----------------------

1. API Handler (Lambda + API Gateway)
Purpose: Accept order requests via REST API.

Flow:

HTTP POST /order
Trigger api_handler Lambda
Lambda invokes Step Function execution

2. Step Functions Orchestration
Purpose: Manages order lifecycle using three sequential tasks.

States:

ValidateOrder: Validates JSON input (checks order_id, product, quantity)
StoreOrder: Saves order with PENDING status to DynamoDB
SendToQueue: Sends order to SQS for fulfillment

3. Order Fulfillment (Lambda)
Triggered by: SQS (order_queue)

Behavior:
Simulates processing with 70% chance of success
Updates order status to FULFILLED or FAILED in DynamoDB
On repeated failure, message goes to DLQ

4. DLQ Handler (Lambda)
Triggered by: SQS DLQ (order_dlq)

Action:
Extracts failed SQS messages
Stores them into failed_orders DynamoDB table

5. Code Pipeline with GitHub Trigger
Whenever we push the code to git, we don't need to run terraform init and apply nothing pipeline will create by itself.

-------------------------

✅ Test Execution Steps (Manual Verification)
Follow this sequential test plan to ensure the end-to-end flow works as expected:

1️⃣ Test API Handler Lambda
Goal: Trigger the entire workflow using API Gateway.

Method:
curl -X POST https://<your-api-endpoint>/order \
  -H "Content-Type: application/json" \
  -d '{"order_id":"test001", "product":"Pen", "quantity":2}'
Expected Result: HTTP 200 with message "Validation passed".

2️⃣ Verify Step Function Execution
Go to AWS Step Functions → dofs-step-function.
Check for a new execution started.
Open the execution and verify these steps:
✅ ValidateOrder ran successfully.
✅ StoreOrder updated the DynamoDB table (orders) with status: PENDING.
✅ SendToQueue pushed the order to the order_queue.

3️⃣ Check SQS Queue
Go to AWS SQS → order_queue.
Click "View Messages" or check the Approximate Number of Messages.
You should see one message with the correct order payload.

4️⃣ Verify Fulfill Order Lambda
Go to CloudWatch Logs → /aws/lambda/fulfill_order_lambda.
Look for logs:
Order test001 processed with status: FULFILLED or FAILED.
Based on random simulation:
If successful: orders table is updated with status: FULFILLED.
If failed: status: FAILED, and retried up to 3 times.
After 3 failures, message moves to DLQ.

5️⃣ Check DLQ and DLQ Handler
Go to SQS → DLQ (e.g., order_dlq).
If message is there (after retries), it triggers:
DLQ Handler Lambda, which logs the message.
Adds the failed payload to failed_orders DynamoDB table.

6️⃣ Verify DynamoDB Tables
orders table:
order_id	status
test001	FULFILLED / FAILED
failed_orders table (only if 3 retries failed):
| failed_order_id | payload (order_id, product, quantity) |

-------------------------
Security Practices Implemented
1. Terraform Variables: Used externalized variables (terraform.tfvars) to manage environment-specific and sensitive values (e.g., github_token, project_name, repo_name) instead of hardcoding them.

2. Remote Backend with S3: Configured Terraform remote backend using an S3 bucket to securely store the state file, ensuring state consistency and protection against local data loss.

3. IAM Roles: Created and attached IAM roles for Lambda, CodeBuild, and CodePipeline with required policies to ensure scoped access to AWS resources using the principle of least privilege.

