- **Chapter_4**: Infraestructura modular avanzada usando módulos remotos versionados desde GitHub.
  - Ejemplo de referencia de módulo:
    ```hcl
    module "web_cluster" {
      source = "github.com/usuario/repositorio//ruta/modulo?ref=v0.0.1"
      # variables...
    }
    ```
  - Organización por ambientes (`live/stage`, `live/prod`).
  - Uso de outputs para integración entre servicios y reglas de seguridad extendidas por ambiente.

- **Chapter_5**: Recursos globales e IAM con loops y condicionales.
  - Ejemplo de creación dinámica de usuarios IAM usando listas y `for_each`:
    ```hcl
    variable "user_names" {
      description = "Create IAM users with these names"
      type        = list(string)
      default     = ["neo", "morpheus"]
    }

    resource "aws_iam_user" "users" {
      for_each = toset(var.user_names)
      name     = each.value
    }
    ```
  - Prácticas recomendadas para loops, condicionales y gotchas en Terraform.
# Proyecto de Práctica con Terraform

Este proyecto contiene ejercicios y ejemplos prácticos realizados durante el estudio de **Terraform**, una herramienta de infraestructura como código (IaC) para la gestión de recursos en la nube, principalmente AWS.

## Estructura del Proyecto


- **Chapter_2**: Ejercicios básicos de despliegue de infraestructura en AWS, incluyendo instancias, grupos de seguridad, balanceadores de carga y autoescalado.
  - Uso de variables, outputs y archivos `.env` para gestionar configuraciones.
  - Script `export_env.sh` para exportar variables de entorno y automatizar pruebas.
  - Ejemplo de error de tipado en variables de Terraform (`pruebas/main.tf`).

- **Chapter_3**: Configuración de backend remoto en S3 y DynamoDB para el estado de Terraform.
  - Recursos para crear bucket S3, habilitar versionado y cifrado, y bloquear acceso público.
  - Creación de tabla DynamoDB para bloqueo de estado.
  - Script `export_env.sh` para cargar variables de entorno.
  - Uso de outputs para exponer información relevante.

- **Chapter_4**: Infraestructura modular avanzada usando módulos remotos versionados desde GitHub.
  - Ejemplo de referencia de módulo:
    ```hcl
    module "web_cluster" {
      source = "github.com/usuario/repositorio//ruta/modulo?ref=v0.0.1"
      # variables...
    }
    ```
  - Organización por ambientes (`live/stage`, `live/prod`).
  - Uso de outputs para integración entre servicios y reglas de seguridad extendidas por ambiente.

## Comandos Básicos de Terraform

```bash
terraform init      # Inicializa el directorio de trabajo
terraform plan      # Muestra los cambios que se aplicarán
terraform apply     # Aplica los cambios en la infraestructura
terraform destroy   # Elimina la infraestructura creada
```
## Notas

- Los archivos `.env` contienen variables sensibles y están excluidos del control de versiones mediante `.gitignore`.
- Se recomienda no compartir claves de acceso ni archivos de estado de Terraform públicamente.
- El proyecto está organizado por capítulos para facilitar el aprendizaje progresivo.

## Gestión y migración del estado de Terraform

- Para mover recursos en el estado sin destruir ni recrear, usa `terraform state mv`.
- El bloque `moved {}` en Terraform permite registrar cambios de nombre o ubicación de recursos en el código, facilitando el refactoring sin perder el historial del estado.
- Si realizas cambios en la definición de recursos y `terraform plan` no muestra cambios, pero el recurso no se actualiza, revisa si necesitas usar `terraform state mv` o el bloque `moved {}`.
- Cambiar el nombre, tipo o path de un recurso sin mover el estado puede causar duplicados, pérdida de historial o errores de drift.
- Siempre revisa el plan antes de aplicar y valida que los cambios sean los esperados.

Ejemplo de uso:
```bash
terraform state mv 'old_resource' 'new_resource'
```

Ejemplo de bloque moved en Terraform:
```hcl
moved {
  from = aws_instance.old_name
  to   = aws_instance.new_name
}
```

Más información: https://developer.hashicorp.com/terraform/language/state/migrate
