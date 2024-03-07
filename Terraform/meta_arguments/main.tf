resource "local_file" "pets" {
  filename = var.filename
  content = "My favourit pet is Mr.Cat"
  depends_on = [ random_pet.my-pet ]
}

resource "random_pet" "my-pet" {
  prefix = var.prefix[0]
  separator = var.separator
  length = var.length
}   




