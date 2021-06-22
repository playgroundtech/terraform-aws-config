output "aws_logs_bucket_arn" {
  description = "Arn of the S3 bucket containing AWS logs."
  value       = local.bucket_arn
}

output "aws_logs_bucket_id" {
  description = "ID of the S3 bucket containing AWS logs."
  value       = local.bucket_id
}

output "aws_config_role_arn" {
  description = "The ARN of the AWS config role."
  value       = aws_iam_role.config_role.arn
}

output "aws_config_role_name" {
  description = "The name of the IAM role used by AWS config"
  value       = aws_iam_role.config_role.name
}

output "aws_config_role_id" {
  description = "The ID of the IAM role used by AWS config"
  value       = aws_iam_role.config_role.id
}
