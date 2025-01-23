data "aws_iam_policy_document" "rest_api_policy_doc" {
    statement {
        sid = "apigwpolicy"
        actions = [
            "lambda:InvokeFunction"
        ]
        effect = "Allow"
        resources = var.lambda_arn_list
    }
}

resource "aws_iam_policy" "rest_api_policy" {
    name = format("%s-%s", var.prefix, "apigwrestapipolicy") 
    path = "/"
    policy = data.aws_iam_policy_document.rest_api_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "rest_api_role_attachment" {
    role = aws_iam_role.apigw_role.name
    policy_arn = aws_iam_policy.rest_api_policy.arn
}