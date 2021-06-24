resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "terraform-dynamodb"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "user_id"
  range_key      = "query_num"

  attribute {
    name = "user_id"
    type = "N"
  }

  attribute {
    name = "query_num"
    type = "N"
  }
}