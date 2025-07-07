locals {
  instance_size = var.instance_type == "small" ? "t2.micro" : "t2.large"
  message = [for s in var.names : "welecome ${s}"]
}