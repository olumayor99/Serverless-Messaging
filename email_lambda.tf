resource "aws_lambda_function" "email" {
  filename      = "email_lambda.py"
  function_name = "email"
  role          = aws_iam_role.serverless_messaging.arn
  handler       = "email_lambda.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = base64sha256(file("${path.module}/lambda_functions/email_lambda.py"))

  environment {
    variables = {
      # Create a zip file of the email_lambda.py file at runtime
      ZIP_FILE = base64encode(file("${path.module}/lambda_functions/email_lambda.py"))
      SourceEmail = var.SourceEmail
    }
  }

  timeout         = 10
  memory_size     = 128
}