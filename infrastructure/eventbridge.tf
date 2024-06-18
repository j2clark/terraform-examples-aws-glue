resource "aws_cloudwatch_metric_alarm" "glue_job_failure" {
  alarm_name          = "${local.project_name}-job-failure"
  alarm_description   = "Number of failed jobs"
  statistic           = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 1
  # period is in seconds. 10, 30 or 60*n
  period              = "60"
  evaluation_periods  = "2"

  namespace           = local.project_name
  metric_name         = "JobFailure"

  dimensions = {
    APPLICATION = local.project_name
    BRANCH = var.branch
  }

  actions_enabled     = "true"
  alarm_actions       = [
    aws_sns_topic.glue_failures.arn
  ]

  tags = local.common_tags
}