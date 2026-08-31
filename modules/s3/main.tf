resource "aws_s3_bucket" "user" {
    bucket = var.bucket_service
}

resource "aws_s3_bucket" "frontend" {
    bucket = var.bucket_frontend
}

data "aws_iam_policy_document" "frontend" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.frontend.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = var.cloudfront_distribution_arn
    }
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend.json
}

data "aws_iam_policy_document" "user" {
  statement {
      sid = "PublicReadObjects"
      effect =  "Allow"
      principals {
        type        = "AWS"
        identifiers = ["*"]
    }
      actions =  ["s3:GetObject"]
      resources =  ["${aws_s3_bucket.user.arn}/*"]
    }
}

resource "aws_s3_bucket_policy" "user" {
  bucket = aws_s3_bucket.user.id
  policy = data.aws_iam_policy_document.user.json
  depends_on = [ aws_s3_bucket_public_access_block.this ]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.user.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [ aws_s3_bucket.user ]
}