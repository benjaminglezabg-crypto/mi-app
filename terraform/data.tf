data "aws_ecs_cluster" "main" {
  cluster_name = var.ecs_cluster_name
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_security_group" "ecs" {
  id = var.ecs_security_group_id
}

data "aws_lb_target_group" "app" {
  arn = var.target_group_arn
}
