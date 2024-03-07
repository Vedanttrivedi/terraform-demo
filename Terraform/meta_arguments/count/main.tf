resource "local_file" "pet" {
  filename = var.filename[count.index]
  count = length(var.filename)
  content = "This is file"
}

output "pets" {
  value = local_file.pet
  sensitive = true
}