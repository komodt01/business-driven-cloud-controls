############################################
# EventBridge rule: detect risky changes
############################################
resource "aws_cloudwatch_event_rule" "s3_acl_changes" {
  count        = var.enable_apply ? 1 : 0
  name         = "s3_acl_changes"
  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["AWS API Call via CloudTrail"],
    "detail": { "eventSource": ["s3.amazonaws.com"], "eventName": ["PutBucketAcl","PutBucketPolicy"] }
  })
}

resource "aws_cloudwatch_event_target" "remediator" {
  count = var.enable_apply ? 1 : 0
  rule  = aws_cloudwatch_event_rule.s3_acl_changes[0].name     # <-- [0]
  arn   = aws_lambda_function.remediator[0].arn                # <-- [0]
}

resource "aws_lambda_permission" "allow_events" {
  count         = var.enable_apply ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remediator[0].function_name  # <-- [0]
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_acl_changes[0].arn  # <-- [0]
}


