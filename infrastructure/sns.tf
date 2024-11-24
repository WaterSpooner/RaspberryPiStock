resource "aws_sns_topic" "stock_notifier_topic" {
    name = "stock_notifier_topic"
}

resource "aws_lambda_permission" "allow_sns" {
    statement_id  = "AllowExecutionFromSNS"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.stock_notifier_lambda.function_name
    principal     = "sns.amazonaws.com"
}

resource "aws_sns_topic_subscription" "topic_sms_subscription" {
  topic_arn = aws_sns_topic.stock_notifier_topic.arn
  protocol  = "sms"
  endpoint  = var.phone_number
}