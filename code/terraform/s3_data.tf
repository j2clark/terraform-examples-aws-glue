resource "aws_s3_object" "object" {
  bucket = data.aws_s3_bucket.artifacts.bucket
  key    = "${var.branch}/input/example.data.txt"
  source = "../data/example.data.txt"
  etag = filemd5("../data/example.data.txt")
}