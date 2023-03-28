resource "aws_api_gateway_rest_api" "serverless_messaging" {
  name        = "Serverless_Messaging"
  description = "Messaging with SMS and Email"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "serverless_messaging" {
  rest_api_id = aws_api_gateway_rest_api.serverless_messaging.id
  parent_id   = aws_api_gateway_rest_api.serverless_messaging.root_resource_id
  path_part   = "sending"
}

data "aws_caller_identity" "current" {}

resource "aws_api_gateway_integration" "sending_integration" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_messaging.id
  resource_id             = aws_api_gateway_resource.serverless_messaging.id
  http_method             = aws_api_gateway_method.serverless_messaging.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.api.function_name}/invocations"
}

resource "aws_api_gateway_method" "serverless_messaging" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_messaging.id
  resource_id   = aws_api_gateway_resource.serverless_messaging.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_deployment" "serverless_messaging" {
  depends_on = [aws_api_gateway_method.serverless_messaging]
  rest_api_id = aws_api_gateway_rest_api.serverless_messaging.id
  stage_name = "sendingStage"
}

resource "aws_lambda_permission" "serverless_messaging" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "serverless_messaging"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.serverless_messaging.id}/*/POST/sending"
}

