resource "aws_cloudwatch_metric_alarm" "nlb_healthyhosts" {
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
#     aws_sns_topic.alarm.arn
#   ]

  tags = local.common_tags
}

# resource "aws_cloudwatch_event_target" "sns" {
#   rule      = aws_cloudwatch_event_rule.console.name
#   target_id = "SendToSNS"
#   arn       = aws_sns_topic.aws_logins.arn
# }

# resource "aws_sns_topic" "aws_logins" {
#   name = "aws-console-logins"
# }

# data "aws_iam_policy_document" "sns_topic_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["SNS:Publish"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }
#
#     resources = [aws_sns_topic.aws_logins.arn]
#   }
# }
# resource "aws_cloudwatch_metric_alarm" "foobar" {
#   alarm_name                = "${local.name_prefix}-alarm"
#   alarm_description         = "This metric monitors job exceptions for ${aws_glue_job.framework_job.name}"
#   comparison_operator       = "GreaterThanUpperThreshold"
#   statistic                 = "Sum"
#   evaluation_periods        = 2
#   insufficient_data_actions = []
#
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#
#   threshold                 = 10
#   alarm_description         = "Request error rate has exceeded 10%"
#
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = 120
#   statistic                 = "Average"
#   insufficient_data_actions = []
# }
#
# resource "aws_cloudwatch_metric_alarm" "nlb_healthyhosts" {
#   alarm_name          = "alarmname"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = 1
#   metric_name         = "HealthyHostCount"
#   namespace           = "AWS/NetworkELB"
#   period              = 60
#   statistic           = "Average"
#   threshold           = var.logstash_servers_count
#   alarm_description   = "Number of healthy nodes in Target Group"
#   actions_enabled     = "true"
#   alarm_actions       = [aws_sns_topic.sns.arn]
#   ok_actions          = [aws_sns_topic.sns.arn]
#   dimensions = {
#     TargetGroup  = aws_lb_target_group.lb-tg.arn_suffix
#     LoadBalancer = aws_lb.lb.arn_suffix
#   }
# }

# resource "aws_cloudwatch_composite_alarm" "example" {
#   alarm_description = "This is a composite alarm!"
#   alarm_name        = "example-composite-alarm"
#
#   alarm_actions = aws_sns_topic.example.arn
#   ok_actions    = aws_sns_topic.example.arn
#
#   alarm_rule = <<EOF
# ALARM(${aws_cloudwatch_metric_alarm.alpha.alarm_name}) OR
# ALARM(${aws_cloudwatch_metric_alarm.bravo.alarm_name})
# EOF
#
#   actions_suppressor {
#     alarm            = "suppressor-alarm"
#     extension_period = 10
#     wait_period      = 20
#   }
# }