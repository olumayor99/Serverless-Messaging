resource "aws_sfn_state_machine" "serverless_messaging" {
  name = "Serverless_Messaging"
  role_arn = aws_iam_role.serverless_messaging.arn

  definition = jsonencode({
    Comment = "State machine for sending SMS & email"
    StartAt = "Select Type of Sending"
    States = {
      "Select Type of Sending" = {
        Type = "Choice"
        Choices = [
          {
            Variable = "$.typeOfSending"
            StringEquals = "email"
            Next = "Email"
          },
          {
            Variable = "$.typeOfSending"
            StringEquals = "sms"
            Next = "SMS"
          },
        ]
      }
      "Email" = {
        Type = "Task"
        Resource = "${aws_lambda_function.email.arn}"
        End = true
      }
      "SMS" = {
        Type = "Task"
        Resource = "${aws_lambda_function.sms.arn}"
        End = true
      }
    }
  })
}
