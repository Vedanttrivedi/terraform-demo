output "os-version" {
  value = data.local_file.os
}
data "local_file" "os" {
  filename = "/etc/os-release"
}