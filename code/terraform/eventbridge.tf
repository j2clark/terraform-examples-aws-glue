resource "aws_cloudwatch_metric_alarm" "glue_job_failure" {
  alarm_name          = "${local.name_prefix}-failed-gluejob"
  alarm_description   = "Number of failed jobs"
  statistic           = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 1
  # period is in seconds. 10, 30 or 60*n
  period              = "60"
  evaluation_periods  = "5"

  namespace           = "examples-aws-glue"
  metric_name         = "GlueJobException"

  dimensions = {
    GLUE_JOB = aws_glue_job.framework_job.name
    BRANCH = var.branch
  }

#   actions_enabled     = "true"
#   alarm_actions       = [
#     aws_sns_topic.glue_failures.arn
#   ]

  tags = local.common_tags
}