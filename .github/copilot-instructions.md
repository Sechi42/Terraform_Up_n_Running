# Instrucciones Copilot para el Proyecto de Práctica con Terraform

## Descripción General
Este repositorio es un proyecto práctico para aprender Terraform, enfocado en infraestructura como código sobre AWS. El proyecto está organizado por capítulos, cada uno mostrando conceptos y flujos de trabajo clave de Terraform.

## Estructura del Proyecto
  - Uso de variables, outputs y archivos `.env` para la configuración.
  - `export_env.sh` automatiza la carga de variables de entorno para pruebas.
  - `pruebas/` contiene ejemplos, incluyendo errores de tipo intencionados para aprendizaje.
  - Estructura por ambientes (`stage`, `prod`, `mgmt`, `global`) y dominios (por ejemplo, `services/webserver-cluster`).
  - Cada servicio o dominio se organiza en subcarpetas con archivos `main.tf`, `variables.tf` y `outputs.tf` para parametrización y reutilización.
  - Provisión de recursos globales (IAM, S3) bajo `global/`.
  - Uso de outputs para exponer información clave de los recursos y facilitar la integración entre módulos.
  - `export_env.sh` para la configuración del entorno.
 El código real y operativo se encuentra únicamente en las carpetas `Chapter_3/global` (recursos globales como IAM, S3) y `Chapter_3/stage` (servicios, VPC, etc. para el ambiente de stage).
 La carpeta `layout` es solo una estructura de referencia para planificar la organización futura, pero no contiene código Terraform ejecutable.

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

## Puntos de Integración
- AWS es el proveedor principal; asegúrate de definir las credenciales mediante variables de entorno o archivos `.env`.
- El estado remoto utiliza S3 y DynamoDB (ver `Chapter_3/global` y archivos de backend en cada ambiente).

## Ejemplos
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

## Referencias
- Consulta `README.md` para más detalles y contexto.
- Archivos clave: `Chapter_2/main.tf`, `Chapter_2/export_env.sh`, `Chapter_3/global/`, `Chapter_3/stage/services/webserver-cluster/`, `Chapter_3/stage/services/webserver-cluster/variables.tf`, `Chapter_3/stage/services/webserver-cluster/outputs.tf`

---
Edita este archivo para actualizar la guía de codificación específica del proyecto.
