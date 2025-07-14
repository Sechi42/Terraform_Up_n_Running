# Instrucciones Copilot para el Proyecto de Práctica con Terraform

## Descripción General
Este repositorio es un proyecto práctico para aprender Terraform, enfocado en infraestructura como código sobre AWS. El proyecto está organizado por capítulos, cada uno mostrando conceptos y flujos de trabajo clave de Terraform.

## Estructura del Proyecto
- `Chapter_2/`: Infraestructura básica en AWS (EC2, grupos de seguridad, balanceadores de carga, autoescalado).
  - Uso de variables, outputs y archivos `.env` para la configuración.
  - `export_env.sh` automatiza la carga de variables de entorno para pruebas.
  - `pruebas/` contiene ejemplos, incluyendo errores de tipo intencionados para aprendizaje.
- `Chapter_3/`: Gestión de estado remoto con S3 y DynamoDB.
  - Provisión de buckets S3 (con versionado, cifrado, bloqueo de acceso público) y tablas DynamoDB para bloqueo de estado.
  - Uso de outputs para exponer información clave de los recursos.
  - `export_env.sh` para la configuración del entorno.

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
- Cada capítulo es autónomo y puede ejecutarse de forma independiente.
- Usa outputs para exponer atributos importantes de los recursos.
- Los scripts (`export_env.sh`) permiten una configuración repetible del entorno.
- Los errores de ejemplo (por ejemplo, en `pruebas/main.tf`) son intencionados para aprendizaje.

## Puntos de Integración
- AWS es el proveedor principal; asegúrate de definir las credenciales mediante variables de entorno o archivos `.env`.
- El estado remoto utiliza S3 y DynamoDB (ver `Chapter_3/main.tf`).

## Ejemplos
- Para inicializar y aplicar el Capítulo 2:
  ```bash
  cd Chapter_2
  source export_env.sh
  terraform init
  terraform apply
  ```
- Para destruir recursos:
  ```bash
  terraform destroy
  ```

## Referencias
- Consulta `README.md` para más detalles y contexto.
- Archivos clave: `Chapter_2/main.tf`, `Chapter_2/export_env.sh`, `Chapter_3/main.tf`, `Chapter_3/export_env.sh`

---
Edita este archivo para actualizar la guía de codificación específica del proyecto.
