resource "aws_s3_bucket" "terraform" {
  bucket = "${var.s3_bucket}"

  tags = {
    Name        = "${var.s3_bucket_name}"
    Environment = "${var.env}"
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform" {
  name           = "${var.dynamodb_table}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
