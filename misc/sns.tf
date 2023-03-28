resource "aws_sns_topic" "serverless_messaging" {
  name = "Serverless_Messaging"
}

resource "aws_sns_topic_subscription" "my_phone_subscription" {
  topic_arn = aws_sns_topic.serverless_messaging.arn
  protocol  = "sms"
  endpoint  = "+1-555-555-5555"
}