resource "aws_ses_email_identity" "source_email" {
  email = "source@example.com"
}

resource "aws_ses_email_identity" "destination_email" {
  email = "destination@example.com"
}