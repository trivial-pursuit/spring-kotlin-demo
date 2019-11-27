resource "aws_s3_bucket" "guestbook" {
  bucket = "tbayer-guestbook-static"
  acl    = "public-read"
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::tbayer-guestbook-static/*"
      ]
    }
  ]
}
EOF
  website {
    index_document = "index.html"
  }
}

data "template_file" "index-template" {
  template = "${file("../src/main/resources/static/index.tpl")}"
  vars = {
    endpoint = "${aws_api_gateway_deployment.guestbook-api-deployment-default.invoke_url}"
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.guestbook.bucket}"
  key    = "index.html"
  acl    = "public-read"
  content = "${data.template_file.index-template.rendered}"
  content_type = "text/html"
}
