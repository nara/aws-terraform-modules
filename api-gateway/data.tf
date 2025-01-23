data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "template_file" "openapi_template" {
    template = "${file(var.openapi_file_path)}" #"${file("${path.module}/openapi/rest-api.yml")}"
    vars = merge({execution_role_arn = aws_iam_role.apigw_role.arn, 
            current_region = data.aws_region.current.name
        }, var.openapi_template_variables)
}