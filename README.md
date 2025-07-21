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

---
