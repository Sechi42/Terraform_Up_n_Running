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

### Modularización y réplicas multi-región con múltiples providers

Para crear recursos dependientes en varias regiones (por ejemplo, una base de datos primaria y una réplica), sigue este patrón:

1. Declara un provider por cada región, usando `alias`:
   ```hcl
   provider "aws" {
     region = "us-east-2"
     alias  = "primary"
   }

   provider "aws" {
     region = "us-west-1"
     alias  = "replica"
   }
   ```

2. Haz tus módulos agnósticos al provider (no declares provider dentro del módulo, solo usa recursos de AWS).

3. Al instanciar el módulo, usa el argumento `providers` para asignar el provider adecuado:
   ```hcl
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

4. En el módulo, usa condicionales para que los parámetros obligatorios solo se requieran cuando sean necesarios (por ejemplo, username/password solo si no es réplica).

Este patrón permite crear infraestructuras multi-región, con recursos dependientes y alta disponibilidad, de forma DRY y reutilizable.
## Chapter 5: Buenas prácticas avanzadas y recursos globales

- Ejercicios de IAM y recursos globales en `Chapter_5/live/global/iam`.
- Uso de variables tipo lista y bucles (`for_each`, `count`) para crear múltiples recursos dinámicamente (por ejemplo, usuarios IAM).
- Ejemplo:
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
- Se recomienda documentar los gotchas y patrones comunes al usar loops y condicionales en Terraform.

# Instrucciones Copilot para el Proyecto de Práctica con Terraform

## Descripción General
Este repositorio es un proyecto práctico para aprender Terraform, enfocado en infraestructura como código sobre AWS. El proyecto está organizado por capítulos, cada uno mostrando conceptos y flujos de trabajo clave de Terraform.

## Estructura del Proyecto
  - Uso de variables, outputs y archivos `.env` para la configuración.
  - `export_env.sh` automatiza la carga de variables de entorno para pruebas.
  - `pruebas/` contiene ejemplos, incluyendo errores de tipo intencionados para aprendizaje.
  - Estructura por ambientes (`stage`, `prod`, `mgmt`, `global`) y dominios (por ejemplo, `services/webserver-cluster`).
  - Cada servicio o dominio se organiza en subcarpetas con archivos `main.tf`, `variables.tf` y `outputs.tf` para parametrización y reutilización.
  - Los módulos pueden ser referenciados como remotos desde GitHub usando tags de versión (`ref=v0.0.1`), lo que permite control de versiones y reutilización segura.
  - Ejemplo de referencia:
    ```hcl
    module "web_cluster" {
      source = "github.com/usuario/repositorio//ruta/modulo?ref=v0.0.1"
      # variables...
    }
    ```
  - Los módulos deben exponer recursos clave (por ejemplo, IDs de security groups, nombres de ASG, DNS de ALB) mediante outputs en `outputs.tf`.
  - Para agregar reglas adicionales a un security group creado en un módulo, usa el output correspondiente (`security_group_id`) y crea recursos `aws_security_group_rule` en el root module o ambiente deseado, apuntando a ese ID. Así puedes personalizar reglas por ambiente sin modificar el módulo base.
  - Se recomienda la integración entre servicios usando `terraform_remote_state` para consumir outputs de otros stacks (por ejemplo, el clúster webserver obtiene la dirección y puerto de la base de datos MySQL).
  - El uso de `aws_launch_template` y `user_data` dinámico con `templatefile` permite pasar variables y endpoints entre servicios de forma segura y DRY.
  - Provisión de recursos globales (IAM, S3) bajo `global/`.
  - Uso de outputs para exponer información clave de los recursos y facilitar la integración entre módulos y la extensión de reglas de seguridad.
  - `export_env.sh` para la configuración del entorno.

El código real y operativo se encuentra en las carpetas `Chapter_3/global`, `Chapter_3/stage`, `Chapter_4/live` y `Chapter_6` (gestión de secretos, KMS, ejemplos de cifrado y desencriptado de credenciales). Chapter_4 y Chapter_6 usan módulos remotos versionados para mayor flexibilidad.
La carpeta `layout` es solo una estructura de referencia para planificar la organización futura, pero no contiene código Terraform ejecutable.
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

## Flujos de Trabajo Clave
- **Comandos Terraform:**
  - `terraform init` — Inicializa el directorio de trabajo
  - `terraform plan` — Previsualiza los cambios
  - `terraform apply` — Aplica los cambios
  - `terraform destroy` — Elimina la infraestructura
- **Configuración del entorno:**
  - Ejecuta `export_env.sh` antes de aplicar Terraform para definir las variables de entorno necesarias (por ejemplo, credenciales AWS).
- **Datos sensibles:**
  - Los archivos `.env` se usan para secretos y están en `.gitignore`. Nunca subas credenciales ni archivos de estado.

## Convenciones y Patrones
- Cada capítulo o ambiente es autónomo y puede ejecutarse de forma independiente.
- Usa outputs y variables para exponer atributos importantes y parametrizar servicios.
- Los servicios y recursos se organizan en subcarpetas para mantener el código DRY y modular.
- Los scripts (`export_env.sh`) permiten una configuración repetible del entorno.
- Los errores de ejemplo (por ejemplo, en `pruebas/main.tf`) son intencionados para aprendizaje.
- Para extender reglas de seguridad, define reglas adicionales (`aws_security_group_rule`) en el root module usando el output del security group del módulo. Así puedes abrir puertos extra o reglas específicas por ambiente sin modificar el módulo base.

## Puntos de Integración
- AWS es el proveedor principal; asegúrate de definir las credenciales mediante variables de entorno o archivos `.env`.
- El estado remoto utiliza S3 y DynamoDB (ver `Chapter_3/global` y archivos de backend en cada ambiente).

- Para inicializar y aplicar un servicio en un ambiente (por ejemplo, webserver-cluster en stage):
  ```bash
  cd Chapter_3/stage/services/webserver-cluster
  terraform init
  terraform apply
  ```
- Para consumir outputs de otro stack (por ejemplo, la dirección de la base de datos MySQL en el clúster webserver):
  ```hcl
  data "terraform_remote_state" "example" {
    backend = "s3"
    config = {
      bucket = "terraform-up-and-running-state-evolu"
      key    = "stage/data-stores/mysql/terraform.statte"
      region = "us-east-2"
    }
  }
  # Uso en recursos:
  db_address = data.terraform_remote_state.example.outputs.address
  db_port    = data.terraform_remote_state.example.outputs.port
  ```
- Para destruir recursos:
  ```bash
  terraform destroy
  ```
- Para inicializar y aplicar el Capítulo 2:
  ```bash
  cd Chapter_2
  source export_env.sh
  terraform init
  terraform apply
  ```
- Para inicializar y aplicar un servicio en un ambiente (por ejemplo, webserver-cluster en stage):
  ```bash
  cd Chapter_3/stage/services/webserver-cluster
  terraform init
  terraform apply
  ```
- Para destruir recursos:
  ```bash
  terraform destroy
  ```

## Gestión avanzada del estado y refactorización

- Usa `terraform state mv` para mover recursos en el estado sin destruirlos ni perder historial.
- El bloque `moved {}` permite registrar cambios de nombre o path de recursos en el código, facilitando el refactoring seguro.
- Si cambias el nombre, tipo o path de un recurso y `terraform plan` no muestra cambios, pero el recurso no se actualiza, revisa si necesitas usar `terraform state mv` o el bloque `moved {}`.
- Cambios incorrectos pueden causar duplicados, drift o pérdida de historial en el estado.
- Siempre valida el plan antes de aplicar y revisa los cambios esperados.

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

## Referencias
- Consulta `README.md` para más detalles y contexto.
- Archivos clave: `Chapter_2/main.tf`, `Chapter_2/export_env.sh`, `Chapter_3/global/`, `Chapter_3/stage/services/webserver-cluster/`, `Chapter_3/stage/services/webserver-cluster/variables.tf`, `Chapter_3/stage/services/webserver-cluster/outputs.tf`

---
Edita este archivo para actualizar la guía de codificación específica del proyecto.
