variable "name" {
  type = string
  default = "ihab"
}

locals {
  render_example_file = templatefile("${path.module}/example.tpl", {
    name = var.name
  })
}

output "example_tpl" {
  value = local.render_example_file
}