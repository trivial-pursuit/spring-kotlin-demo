resource "aws_dynamodb_table" "guestbook" {
  name           = "guestbook"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "fromUser"
    type = "S"
  }

  global_secondary_index {
    name               = "FromUserIndex"
    hash_key           = "fromUser"
    projection_type    = "ALL"
  }
}



