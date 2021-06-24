#------------------------------------------------------------
# API Gateway
#------------------------------------------------------------
## Create API Gateway
resource "aws_api_gateway_rest_api" "get_unixtime" {
  name        = "get-unix-time"
  description = "Terraform Serverless Application Example"
}

## Create resource
resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.get_unixtime.id
   parent_id   = aws_api_gateway_rest_api.get_unixtime.root_resource_id
   path_part   = "{proxy+}"
}

## Create proxy
resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.get_unixtime.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

# Setting 統合リクエスト
# uriにLambda関数のarnを指定する
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.get_unixtime.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.get_unixtime.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.get_unixtime.id
   resource_id   = aws_api_gateway_rest_api.get_unixtime.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.get_unixtime.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.get_unixtime.invoke_arn
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "get_unixtime" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.get_unixtime.id
   stage_name  = "test"
}

# Deploy URL にすぐアクセスできるようにコンソール出力する
output "base_url" {
  value = aws_api_gateway_deployment.get_unixtime.invoke_url
}
