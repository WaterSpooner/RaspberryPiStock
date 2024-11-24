data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_stock_notifier_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_files" {
  type        = "zip"
  source_dir = "../lambda"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "stock_notifier_lambda" {
  filename      = data.archive_file.lambda_files.output_path
  function_name = "stock_notifier"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main.handler"

  source_code_hash = data.archive_file.lambda_files.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      INTERVAL = var.schedule_interval
      SNS_TOPIC_ARN = aws_sns_topic.stock_notifier_topic.arn
      PI_MODEL = var.pi_model
      SHOP_REGION = var.shop_region
      RSS_FEED = var.rss_feed
    }
  }
}