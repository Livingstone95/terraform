module "vpc" {
  source                         = "./networking"
  region                         = var.region
  vpc_cidr                       = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  max_subnets                    = 10
  public_sn_count                = 2
  private_sn_count               = 4
  private_cidrs                  = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_cidrs                   = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_key_path = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDU9g5rGZQS7PjuFQW0UkPktmL6L0t2qFQQkI1NkEPD0URvaFNgqzXaj4yPKTxi8fu/twyrl8/k/7+luJFnpVwWBBI4zJQML66Sdq8I2fCfcMb7XR52toWtdrZix2ySdCFy7te2aHkSpf4mK8KSRl4LVvr9Zu7wzKiMrwwz1/5SDOAkFsLaLJSH8ROcNzcW917lK5xQMwlUhWj6OoGKzPNv8GJy4kw8jtZ8cEPW444G6qPZXz6MogWGf616OZy/MN3GbceFKa5tOEaiZk6bMItIBh5XJyFthcCop3oLDFmOAno0EwbtmAQ17J5G2jkNsytT+QUGQWVtiQBqHLjCknFE/bJL4ME+s5HTBsvhrwxReSKFoLuT6whA+B6pMKC0LSRqz4i4tieNADs2xJZ2lYvd6xrrFkVi5iVxKUkOmfLo9z4k1MDJEaPhLpo3t8RmbonU0aM444I1A52tImBUn6Yp9DU9Ls0kJPQ5SkEjFXbYOYe56vdnOENq+uZyizQdBoc= livingstone@Adebayo-Segun"

}


