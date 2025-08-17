variable "name" {
    description = "The name of all resouces created by this module"
    type        = string
}

variable "image" {
    description = "Docker image to run"
    type        = string
}

variable "container_port" {
    description = "The port the Docker image listens on"
    type        = number
}

variable "replicas" {
    description = "How many replicas to run"
    type        = number
}

variable "enviroment_variables" {
    description = "Enviroment variables to set for the app"
    type        = map(string)
    default = {
      
    }
}
