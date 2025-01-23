locals{
    api_version = var.api_type == "rest-api" || var.api_type == "mqtt" ? 1 : (var.api_type == "http" || var.api_type == "websocket" ? 2 : 0 )
    openapi_template = data.template_file.openapi_template.rendered
    protocol_type = upper(var.api_type)
}