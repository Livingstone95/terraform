locals {
  security_groups = {
    ALB = {
      name        = "ALB-sg"
      description = "for external loadbalncer"
      ingress = {
        HTTPS = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

          HTTP = {
            from        = 80
            to          = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

          }
        }
      }

    }

    bastion = {
      name        = "bastion-sg"
      description = "for bastion instances"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }

    nginx = {
      name        = "nginx-sg"
      description = "nginx instances"
      ingress = {
        HTTPS = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = [aws_security_group.david-sg["ALB"].id]

          HTTP = {
            from        = 80
            to          = 80
            protocol    = "tcp"
            cidr_blocks = [aws_security_group.david-sg["ALB"].id]

            ssh = {
              from        = 22
              to          = 22
              protocol    = "tcp"
              cidr_blocks = [aws_security_group.david-sg["bastion"].id]

            }

          }
        }

      }

    }
    IALB = {
      name        = "IALB-sg"
      description = "IALB security group"
      ingress = {
        HTTPS = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = [aws_security_group.david-sg["nginx"].id]

          HTTP = {
            from        = 80
            to          = 80
            protocol    = "tcp"
            cidr_blocks = [aws_security_group.david-sg["nginx"].id]

          }
        }

      }

    }   

    webservers = {
      name        = "webservers-sg"
      description = "webservers security group"
      ingress = {
        HTTPS = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = [aws_security_group.david-sg["IALB"].id]

          HTTP = {
            from        = 80
            to          = 80
            protocol    = "tcp"
            cidr_blocks = [aws_security_group.david-sg["IALB"].id]

            ssh = {
              from        = 22
              to          = 22
              protocol    = "tcp"
              cidr_blocks = [aws_security_group.david-sg["bastion"].id]
            }
          }
        }
      }
    }

    data-layer = {
      name        = "DL-sg"
      description = "data layer security group"
      ingress = {
        nfs = {
          from        = 2049
          to          = 2049
          protocol    = "tcp"
          cidr_blocks = [aws_security_group.david-sg["webservers"].id]
          mysql = {
            from        = 3306
            to          = 3306
            protocol    = "tcp"
            cidr_blocks = [aws_security_group.david-sg["webservers"].id]

            ssh = {
              from        = 22
              to          = 22
              protocol    = "tcp"
              cidr_blocks = [aws_security_group.david-sg["bastion"].id]
            }
          }
        }

      }
    }
  }
}


