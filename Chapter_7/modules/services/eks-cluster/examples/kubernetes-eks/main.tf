provider "aws" {
  region = "us-east-2"
}

module "eks_cluster" {
    source = "../../../../../../Chapter_7/modules/services/eks-cluster"

    name = "example-eks-cluster"    
    min_size = 1
    max_size = 2
    desired_size = 1

    # Instancia mínima recomendada: t3.small
    # Resumen:
    # - t3.small proporciona ENIs/IPs y recursos suficientes para kube-proxy, kubelet y pods del sistema.
    # - Instancias más pequeñas pueden quedarse sin IPs, provocar pods Pending e inestabilidad.
    # Para mayor densidad/carga, usar t3.medium o familias con más ENIs (p.ej. m5).

    instance_type = ["t3.small"]
}

provider "kubernetes" {
  host = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(
    module.eks_cluster.cluster_certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_name
}

module "simple_webapp" {
    source = "../../../../../../Chapter_7/modules/services/k8-app"
    
    name           = "simple-webapp"
    image          = "nginx"
    replicas       = 2
    container_port = 80

    enviroment_variables = {
      PROVIDER = "Terraform"
    }

    # Solo se despliega después del cluster
    depends_on = [ module.eks_cluster ]
}