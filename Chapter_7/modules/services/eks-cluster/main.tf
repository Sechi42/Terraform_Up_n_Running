# Crear un rol IAM para el control de plano EKS

resource "aws_iam_role" "cluster" {
  name = "${var.name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
}

data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Attach del permiso que el role de IAM necesita

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    role       = aws_iam_role.cluster.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default.if]
    }
}

resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = aws_iam_role.cluster.arn
  version  = "1.21"

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }
  
  # Asegurar que los security groups y recursos asociados existan antes de crear este recurso.
  # Al eliminar, eliminar explícitamente los security groups dependientes para evitar bloqueos en la destrucción.
  # Necesario porque EKS maneja EC2 como grupos de seguridad y puede impedir la eliminación correcta.
  depends_on = [ 
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
   ]
}

# Crear el role IAM para el grupo de nodo

resource "aws_iam_role" "node_group" {
  name = "${var.name}-node_group"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
  
}

# Allow EC2 instances to assume the rol
data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts_AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Agregar los permisos que el grupo de nodos necesita
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ConatinerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ConatinerRegistryReadOnly"
  role       = aws_iam_role.node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group.name
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.name
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = data.aws_subnets.default.ids
  instance_types  = var.instance_type 

  scaling_config {
    min_size     = var.min_size
    max_size     = var.max_size
    desired_size = var.desired_size
  }

  # Asegura que los permisos del rol IAM se creen antes y se eliminen después
  # del EKS Node Group. EKS no podrá eliminar correctamente las instancias EC2
  # y las interfaces de red elásticas (ENI) sin estas dependencias.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ConatinerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
  ]
}