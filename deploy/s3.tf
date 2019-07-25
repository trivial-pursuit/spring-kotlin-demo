resource "aws_s3_bucket" "guestbook" {
  bucket = "tbayer-guestbook"
  acl    = "public-read"
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::tbayer-guestbook/*"
      ]
    }
  ]
}
EOF
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.guestbook.bucket}"
  key    = "index.html"
  source = "../src/main/resources/static/index.html"
  content_type = "text/html"
}
