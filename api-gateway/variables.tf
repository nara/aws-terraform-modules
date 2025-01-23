variable "api_type" {
  default = "rest-api"
  type = string
  description = "Type of api, values should be rest-api, http, mqtt, websocket."
}

variable "api_key_source" {
  default     = "HEADER" #tfsec:ignore:general-secrets-no-plaintext-exposure
  description = "The source of the API key for requests. Valid values are HEADER (default) and AUTHORIZER."
  type        = string
}

variable "binary_media_types" {
  default     = ["UTF-8-encoded"]
  description = "The list of binary media types supported by the RestApi. By default, the RestApi supports only UTF-8-encoded text payloads."
  type        = list(any)
}

variable "description" {
  default     = ""
  description = "Description for the API Gateway."
  type        = string
}

variable "domain_name" {
  description = "The fully-qualified domain name to register"
  type        = string
  default = ""
}

variable "endpoint_configuration" {
  default     = "EDGE"
  description = "API gateway endpoint config. REGIONAL or EDGE"
  type        = string
}

variable "identity_source" {
  default     = "method.request.header.x-api-key"
  type        = string
  description = <<EOT
The source of the identity in an incoming request.
For REQUEST type, this may be a comma-separated list of values, including headers, query string parameters and stage variables - e.g.
`"method.request.header.SomeHeaderName,method.request.querystring.SomeQueryStringName,stageVariables.SomeStageVariableName"`
EOT
}

variable "log_retention_in_days" {
  default     = 30
  description = "Days to retain apigateway logs"
  type        = number
}

variable "minimum_compression_size" {
  default     = -1
  description = "Minimum response size to compress for the REST API. Integer between -1 and 10485760 (10MB). Setting a value greater than -1 will enable compression, -1 disables compression (default)."
  type        = number
}

variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "prefix" {
  description = "Moniker to apply to all resources in the module"
  type        = string
  default = ""
}

variable "provider_arns" {
  default     = []
  type        = list(string)
  description = <<EOT
A list of the Amazon Cognito user pool ARNs. Each element is of this format:
`arn:aws:cognito-idp:{region}:{account_id}:userpool/{user_pool_id}`.
EOT
}

variable "route53_evaluate_target_health" {
  default     = true
  description = "Bool for Route 53 alias target health eval"
  type        = bool
}

variable "security_policy" {
  default     = "TLS_1_2"
  description = "The Transport Layer Security (TLS) version + cipher suite for this DomainName. The valid values are TLS_1_0 and TLS_1_2. Must be configured to perform drift detection."
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}

variable "endppoint_config" {
  default     = ["REGIONAL"]
  type        = list(string)
  description = <<EOT
A list of endpoint types. This resource currently only supports managing a single value.
Valid values: EDGE, REGIONAL or PRIVATE. If unspecified, defaults to REGIONAL. Must be declared as REGIONAL in non-Commercial partitions.
Refer to the documentation for more information on the difference between edge-optimized and regional APIs.
EOT
}

variable "openapi_file_path" {
  default = ""
  type = string
  description = "relative path of open api yaml or json file"
}

variable "openapi_template_variables" {
  default = {}
  type = map
  description = "variables need to pass to openapi template file"
}

variable "lambda_arn_list" {
  type = list(string)
  default = []
  description = "list of lambda ARNs executed by this API"
}

variable "autorizer_type" {
  default = ""
  type = string
  description = "allowed values cognito, okta, managed_ad, azure_ad, oauth2"
}

variable "stage_name" {
  default = "dev"
  type = string
}

variable "oauth2_issuer" {
  default = ""
  type = string
  description = "required for authorizer_type of okta or oauth2."
}

variable "oauth2_audience" {
  default = ""
  type = string
  description = "required for authorizer_type of okta or oauth2."
}

variable "oauth2_client_id" {
  default = ""
  type = string
  description = "required for authorizer_type of okta or oauth2."
}