resource "aws_iam_group" "deploy" {
  name = "deploy-${var.formation}"
  path = "/${var.formation}/"
}

resource "aws_iam_user" "deploy" {
  name = "deploy-${var.formation}"
  path = "/${var.formation}/"
}

resource "aws_iam_access_key" "deploy" {
  user = "${aws_iam_user.deploy.name}"
}

//resource "aws_iam_role" "role_lambda_scaleup" {
//  name = "role-lambda-${var.formation}"
//  path = "/${var.formation}/"
//}

//resource "aws_iam_policy" "iam" {
//  name        = "test_policy"
//  path        = "/"
//  description = "My test policy"
//
//  policy = <<EOF
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Sid": "ViaTerraform0",
//            "Effect": "Allow",
//            "Action": "iam:PassRole",
//            "Resource": [
//                "arn:aws:iam::736423473805:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling_CMK",
//                "arn:aws:iam::736423473805:role/role_lambda_scaleup"
//            ]
//        }
//    ]
//}
//EOF
//}