resource "aws_s3_bucket" "aws_s3_test" {
  bucket = "my-s3-object-uploads"
  force_destroy = true
  tags = {
    Name        = "my-s3-object-uploads"
    Environment = var.env
  }
  
}

resource "aws_sqs_queue" "aws_sqs_test" {
  name                      = "my-sqs-object-uploads"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = var.env
  }
}

resource "aws_sqs_queue_policy" "aws_sqs_policy_s3" {
  queue_url = aws_sqs_queue.aws_sqs_test.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.aws_sqs_test.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.aws_s3_test.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "s3_to_sqs" {
  bucket = aws_s3_bucket.aws_s3_test.id

  queue {
    queue_arn = aws_sqs_queue.aws_sqs_test.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [
  aws_sqs_queue_policy.aws_sqs_policy_s3,
  aws_sqs_queue.aws_sqs_test
]
}

