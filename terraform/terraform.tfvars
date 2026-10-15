resource "aws_ecs_service" "app" {
  name = var.ecs_service_name

  cluster         = data.aws_ecs_cluster.main.arn
  task_definition = data.aws_ecs_task_definition.app.arn

  desired_count = 1
  launch_type   = "FARGATE"

  platform_version = "LATEST"

  network_configuration {
    subnets = data.aws_subnets.private.ids

    security_groups = [
      data.aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.app.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
