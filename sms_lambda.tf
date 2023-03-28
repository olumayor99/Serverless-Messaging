resource "aws_lambda_function" "sms" {
  filename      = "sms_lambda.py"
  function_name = "sms"
  role          = aws_iam_role.serverless_messaging.arn
  handler       = "sms_lambda.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = base64sha256(file("${path.module}/lambda_functions/sms_lambda.py"))

  # Create a zip file of the sms_lambda.py file at runtime
  environment {
    variables = {
      ZIP_FILE = base64encode(file("${path.module}/lambda_functions/sms_lambda.py"))
    }
  }

  timeout         = 10
  memory_size     = 128
}