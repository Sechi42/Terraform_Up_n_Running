# Ejemplo ASG (Auto Scaling Group)

Este directorio contiene una configuración de Terraform que muestra cómo usar el módulo `asg-rolling-deploy` (ubicado en `../../modules/cluster/asg-rolling-deploy`) para desplegar un clúster de servidores web usando EC2 y Auto Scaling en una cuenta de AWS.

Para más información, consulta el capítulo 8, "Código Terraform apto para producción", del libro "Terraform: Up and Running".

## Requisitos previos

- Tener Terraform 1.x instalado en tu equipo.
- Tener una cuenta AWS y credenciales configuradas en variables de entorno o en un perfil.

## Inicio rápido

> Atención: este ejemplo crea recursos reales en tu cuenta AWS. Aunque se han diseñado para minimizar costos y usar recursos compatibles con AWS Free Tier cuando es posible, podrías incurrir en cargos.

Configura tus credenciales AWS como variables de entorno (ejemplo bash/POSIX):

```bash
export AWS_ACCESS_KEY_ID="(tu access key id)"
export AWS_SECRET_ACCESS_KEY="(tu secret access key)"
export AWS_REGION="us-east-2"
```

Inicializa y aplica:

```bash
terraform init
terraform apply
```

Cuando termines, destruye los recursos para evitar cargos:

```bash
terraform destroy
```

## Notas

- El ejemplo está pensado para pruebas y aprendizaje. Revisa variables en `variables.tf` antes de aplicar.
- Asegúrate de borrar recursos (`terraform destroy`) cuando hayas terminado.

---

Si quieres, agrego una versión en inglés o ejemplos de variables comunes (AMI, instance_type, subnets).
