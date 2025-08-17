# Importación del modulo de k8

module "simple_webapp" {
        source         = "../../../../../../Chapter_7/modules/services/k8-app"
        name           = "simple-webapp"
        image          = "nginx"
        replicas       = 2
        container_port = 80

        providers = {
            kubernetes = kubernetes
        }
}

provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
}

