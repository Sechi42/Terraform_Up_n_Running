variable "name" {
    description = "The name to use for the EKS cluster"
    type        = string
}

variable "min_size" {
    description = "Minium number of nodes to have in the EKS cluster"
    type        = number
}

variable "max_size" {
     description = "Maxium number of nodes to have in the EKS cluster"
     type        = number
}

variable "desired_size" {
    description = "The types of nodes to have in the EKS cluster"
    type        = number 
}

variable "instance_type" {
    description = "The types of EC2 instance to run in the node group"
    type        = list(string)
}