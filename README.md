## Chapter 7: Multi-región y despliegue en paralelo

- Ejemplo de despliegue de instancias EC2 en dos regiones distintas usando múltiples providers y datasources.
- Uso de alias en el provider para manejar varias regiones en un mismo stack.
- Obtención dinámica de la AMI más reciente de Ubuntu en cada región.
- Ejemplo de uso:
```hcl
provider "aws" {
  region = "us-east-2"
  alias  = "region_1"
}

provider "aws" {
  region = "us-west-1"
  alias  = "region_2"
}

data "aws_ami" "ubuntu_region_1" {
  provider = aws.region_1
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_region_2" {
  provider = aws.region_2
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "region_1" {
  provider      = aws.region_1
  ami           = data.aws_ami.ubuntu_region_1.id
  instance_type = "t2.micro"
}

resource "aws_instance" "region_2" {
  provider      = aws.region_2
  ami           = data.aws_ami.ubuntu_region_2.id
  instance_type = "t2.micro"
}
```

Este patrón permite desplegar recursos en paralelo en varias regiones AWS desde un solo stack de Terraform.

### Ejemplo avanzado: MySQL multi-región (primaria y réplica)

También puedes desplegar una base de datos MySQL primaria en una región y una réplica en otra usando módulos y providers con alias:

```hcl
provider "aws" {
  region = "us-east-2"
  alias  = "primary"
}

provider "aws" {
  region = "us-west-1"
  alias  = "replica"
}

module "mysql_primary" {
  source = "../../../../modules/data-stores/mysql"
  providers = { aws = aws.primary }
  db_name = "prod_db"
  db_username = var.db_username
  db_password = var.db_password
  backup_retention_period = 1
}

module "mysql_replica" {
  source = "../../../../modules/data-stores/mysql"
  providers = { aws = aws.replica }
  replicate_source_db = module.mysql_primary.arn
}
```

Esto permite alta disponibilidad y recuperación ante desastres entre regiones AWS usando Terraform.
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

## Chapter 6: Gestión de secretos y KMS

- Ejemplo de integración de AWS KMS para cifrado de secretos y uso de archivos encriptados para credenciales de base de datos.
- Uso de `aws_kms_key`, `aws_kms_alias`, y `aws_kms_secrets` para desencriptar y consumir secretos en recursos como RDS.
- Ejemplo de uso en `main.tf`:
```hcl
data "aws_kms_secrets" "creds" {
  secret {
    name    = "db"
    payload = file("Chapter_6/Exploración/mysql-kms/db-creds.yml.encrypted")
  }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

resource "aws_db_instance" "example" {
  # ...
  username = local.db_creds.username
  password = local.db_creds.password
}
```

Para cifrar secretos:
```bash
cd Chapter_6/Exploración/kms-cmk
./encrypt.sh alias/kms-cmk-example us-east-2 db-creds.yml ../mysql-kms/db-creds.yml.encrypted
```

Luego puedes desplegar el stack de base de datos y consumir los secretos desencriptados automáticamente.

## Chapter 8: Módulos y ejemplos adicionales

El directorio `Chapter_8` contiene ejemplos y módulos adicionales organizados en dos áreas principales:

- `Exploración/`: ejemplos y estados de trabajo para pruebas y aprendizaje (contiene `main.tf`, `terraform.tfstate` y `.terraform` con providers instalados localmente).
- `live/`: estructura por ambientes con subcarpetas `global`, `prod` y `stage`. Dentro de `live` hay ejemplos de:
  - `global/iam` y `global/s3` con recursos para IAM y buckets S3.
  - `prod` y `stage` con ejemplos de `data-stores/mysql` y `services/webserver-cluster` (cada uno incluye `main.tf`, `outputs.tf` y archivos de estado de ejemplo).

Además `Chapter_8/modules` contiene módulos reutilizables detectados:
- `cluster/asg-rolling-deploy`: plantilla para despliegues con Auto Scaling y rolling updates.
- `data-stores/mysql`: módulo orientado a bases de datos MySQL.
- `networking/alb`: módulo para ALB (listeners, target groups y reglas).
- `services/hello-world-app`: módulo para desplegar una aplicación sencilla (user-data y variables incluidas).

Recomendaciones rápidas:
- Revisa y limpia los archivos `.terraform` y `terraform.tfstate` en `Exploración/` antes de usarlos como referencia; esos estados pueden contener datos sensibles.
- Usa `terraform init` en cada ejemplo antes de ejecutar `plan`/`apply`.
- Normaliza outputs y variables si vas a referenciar módulos entre capítulos.

