ecs_cluster_name       = "ecs-network-dev-cluster"
task_definition_family = "ecs-network-dev-task"
ecs_service_name       = "ecs-network-dev-service"

vpc_id                 = "vpc-xxxxxxxx"
ecs_security_group_id   = "sg-xxxxxxxx"

target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:ACCOUNT_ID:targetgroup/xxxxx/xxxxx"

container_name = "app"
container_port = 8000
