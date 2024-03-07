resource "local_file" "pets" {
  filename = var.filename
  content = "My favourit pet is ${random_pet.my-pet.id}"
}

resource "random_pet" "my-pet" {
    prefix = var.prefix[0]
    separator = var.separator
    length = var.length
}   

output "pet-name" {
  value = random_pet.my-pet.id
}