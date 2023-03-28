resource "aws_iam_role" "serverless_messaging" {
  name = "Serverless_Messaging"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sns_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  role       = aws_iam_role.serverless_messaging.name
}

resource "aws_iam_role_policy_attachment" "ses_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  role       = aws_iam_role.serverless_messaging.name
}

resource "aws_iam_role_policy_attachment" "stepfunctions_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
  role       = aws_iam_role.serverless_messaging.name
}