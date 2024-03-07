variable "filename" {
  default = "/home/einfochips/Downloads/Repo/pets.txt"
}

variable "prefix" {
    type = list(string)
    default = ["Mr","Mrs","Miss"]
}

variable "separator" {
    default = "."
}

variable "length" {
    default = 1
}