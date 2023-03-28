resource "aws_lambda_function" "api" {
  filename      = "api_lambda.py"
  function_name = "api"
  role          = aws_iam_role.serverless_messaging.arn
  handler       = "api_lambda.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = base64sha256(file("${path.module}/lambda_functions/api_lambda.py"))

  environment {
    variables = {
      ZIP_FILE = base64encode(file("${path.module}/lambda_functions/api_lambda.py"))  # Create a zip file of the api_lambda.py file at runtime
      StateMachineARN = "${aws_sfn_state_machine.serverless_messaging.arn}"
    }
  }

  timeout         = 10
  memory_size     = 128
}