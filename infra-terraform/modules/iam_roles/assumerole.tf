data "aws_caller_identity" "account" {
  
}

resource "aws_iam_role" "k8s_devops_assuemrole" {
  name = "${var.env}_k8s-devops-assumerole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.account.account_id}:root"
        }
      },
    ]
  })
  tags = {
    tag-key = "${var.env}_k8s_devops_assumerole"
  }
}

resource "aws_iam_group" "k8s_devops_assuemgroup" {
  name = "${var.env}_eks-devops-assumegroup"
  path = "/"
}




resource "aws_iam_policy" "k8s_devops_assuempolicy_assumerole_policy" {
  name  = "${var.env}_eksdeveloper-group-policy"
  

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid    = "123"
        Resource = "${aws_iam_role.k8s_devops_assuemrole.arn}"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "k8s_devops_attacheadminpolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  group      = aws_iam_group.k8s_devops_assuemgroup.name
}

resource "aws_iam_group_policy_attachment" "k8s_devops_attacheassumepolicy" {
  policy_arn = aws_iam_policy.k8s_devops_assuempolicy_assumerole_policy.arn
  group      = aws_iam_group.k8s_devops_assuemgroup.name
}