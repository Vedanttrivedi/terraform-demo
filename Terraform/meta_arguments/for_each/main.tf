resource "local_file" "pet" {
  filename = each.value
  for_each =  toset(var.filename)
  content = "This is file"
}

# output "pets" {
#   value = local_file.pet
# }

