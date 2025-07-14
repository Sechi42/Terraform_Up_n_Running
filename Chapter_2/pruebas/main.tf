# Comentario de documentación
# 
# Esta variable define un ejemplo de un tipo de objeto en Terraform con un error intencional de tipo, para fines demostrativos.
#
# Descripción: Un ejemplo de un tipo estructural en Terraform con un error.
# Tipo: Objeto con los siguientes atributos:
#   - name (string): El valor del nombre.
#   - age (number): El valor de la edad.
#   - tags (list de string): Una lista de etiquetas.
#   - enabled (bool): Un indicador booleano que señala si está habilitado.
#
# Nota:
# El valor por defecto para enabled está definido como el string "invalide", lo cual es un error de tipo porque este atributo espera un valor booleano (true o false).
# Esto demuestra un error de tipado (cuando un valor no coincide con el tipo de dato esperado).


variable "object_example_with_error" {
    description = "An example of a structural type in Terraform with an error"
    type        = object({
        name    = string
        age     = number
        tags    = list(string)
        enabled = bool
    })

    default = {
        name    = "value 1"
        age     = 41
        tags    = ["a", "b", "c"]
        enabled = "invalide"
    }
}