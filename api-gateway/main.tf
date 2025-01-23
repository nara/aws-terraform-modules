data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = [
                "apigateway.amazonaws.com"
            ]
        }
    }
}

resource "aws_iam_role" "apigw_role" {
    name = format("%s-%s", var.prefix, "apigw-role")
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
    tags = var.tags
}

resource "aws_api_gateway_rest_api" "this" {
  count = local.api_version == 1 ? 1 : 0
  name                     = var.name
  api_key_source           = var.api_key_source #tfsec:ignore:general-secrets-no-plaintext-exposure
  binary_media_types       = var.binary_media_types
  description              = coalesce(var.description, "${var.name} API Gateway. Terraform Managed.")
  minimum_compression_size = var.minimum_compression_size
  tags                     = var.tags
  body = local.openapi_template

  endpoint_configuration {
    types = var.endppoint_config
  }
}

resource "aws_api_gateway_deployment" "stage" {
  count = local.api_version == 1 ? 1 : 0
  rest_api_id       = aws_api_gateway_rest_api.this.*.id[0]
  stage_name        = var.stage_name
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.*.body[0]
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_api" "this" {
  count = local.api_version == 2 ? 1 : 0

  name          = var.name
  description   = var.description
  protocol_type = local.protocol_type
  body          = local.openapi_template
  tags = var.tags
}

resource "aws_apigatewayv2_stage" "stage" {
  count = local.api_version == 2 ? 1 : 0
  api_id = aws_apigatewayv2_api.this.*.id[0]
  name   = var.stage_name
}

resource "aws_apigatewayv2_deployment" "deploy" {
  count = local.api_version == 2 ? 1 : 0
  api_id       = aws_apigatewayv2_api.this.*.id[0]
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_apigatewayv2_api.this.*.body[0]
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "this" {
  name       = replace(var.prefix, " ", "-")
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}