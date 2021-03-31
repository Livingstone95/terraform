resource "aws_iam_role" "david-role" {
  name = "david-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "david-role"
  }
}

resource "aws_iam_policy" "david-policy" {
  name        = "david_policy"
  path        = "/"
  description = "David policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "david-attach" {
  role       = aws_iam_role.david-role.name
  policy_arn = aws_iam_policy.david-policy.arn
}


resource "aws_iam_instance_profile" "ip" {
  name = "aws_instance_profile_test"
  role = aws_iam_role.david-role.name
}

resource "aws_key_pair" "livingstone" {
  key_name   = "livingstone"
  public_key = var.public_key_path
}


resource "aws_security_group" "david-ALB" {
  name        = "david-ALB"
  description = "Listening to the world"
  vpc_id      = aws_vpc.david.id

  ingress {
    description = "Listening to the world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "david-ALB"
  }
}


resource "aws_security_group" "david-bastion" {
  name        = "david-Bastion"
  description = "Allow traffic from control machine"
  vpc_id      = aws_vpc.david.id

  ingress {
    description = "Allow traffic from control machine"
    from_port   = 22
    to_port     = 22
    protocol    = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "david-Bastion"
  }
}

resource "aws_security_group" "david-nginx" {
  name        = "david-nginx"
  description = "Allow traffic from bastion and ALB"
  vpc_id      = aws_vpc.david.id

  ingress {
    description = "Allow HTTP traffic from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = [aws_security_group.david-ALB.id]
  }

  ingress {
    description = "Allow HTTPS traffic from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "HTTPS"
    cidr_blocks = [aws_security_group.david-ALB.id]
  }

  ingress {
    description = "Allow SSH traffic from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "SSH"
    cidr_blocks = [aws_security_group.david-bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "david-nginx"
  }
}


resource "aws_security_group" "david-IALB" {
  name        = "david-IALB"
  description = "Allow traffic only from niginx"
  vpc_id      = aws_vpc.david.id

  ingress {
    description = "Allow traffic only from nginx"
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = [aws_security_group.david-nginx.id]
  }

  ingress {
    description = "Allow traffic only from nginx"
    from_port   = 443
    to_port     = 443
    protocol    = "HTTPS"
    cidr_blocks = [aws_security_group.david-nginx.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "david-IALB"
  }
}

resource "aws_security_group" "david-webservers" {
  name        = "david-webservers"
  description = "Allow traffic from IALB"
  vpc_id      = aws_vpc.david.id

  ingress {
    description = "Allow traffic only from IALB"
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = [aws_security_group.david-IALB.id]
  }

  ingress {
    description = "Allow traffic only from IALB"
    from_port   = 443
    to_port     = 443
    protocol    = "HTTPS"
    cidr_blocks = [aws_security_group.david-IALB.id]
  }


  ingress {
    description = "Allow SSH traffic from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "SSH"
    cidr_blocks = [aws_security_group.david-bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "david-webservers"
  }
}


resource "aws_security_group" "david-DL" {
  name        = "david-DL"
  description = "Allow traffic from webservers"
  vpc_id      = aws_vpc.david.id

  ingress {
    description = "Allow SSH traffic from Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "SSH"
    cidr_blocks = [aws_security_group.david-bastion.id]
  }

  ingress {
    description = "Allow mysql from traffic from webservers"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.david-webservers.id]
  }
  ingress {
    description = "Allow nfs traffic from webservers"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.david-webservers.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "david-webservers"
  }
}