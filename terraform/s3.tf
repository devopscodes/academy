resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-devopscodes-s3-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "my-bucket" {
  bucket = aws_s3_bucket.my-bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}


resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.my-bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.my-bucket.arn}/*",
    ]
  }
}