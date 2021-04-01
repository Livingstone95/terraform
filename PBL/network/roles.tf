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

