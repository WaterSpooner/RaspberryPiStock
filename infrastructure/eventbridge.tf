resource "aws_cloudwatch_event_rule" "schedule_rule" {
    name                = "schedule_rule"
    schedule_expression = format("rate(%d minutes)", var.schedule_interval)
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.schedule_rule.name
    target_id = aws_lambda_function.stock_notifier_lambda.function_name
    arn       = aws_lambda_function.stock_notifier_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.stock_notifier_lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}