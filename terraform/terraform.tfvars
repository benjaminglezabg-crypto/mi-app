ecs_cluster_name       = "ecs-network-dev-cluster"
task_definition_family = "ecs-network-dev-task"
ecs_service_name       = "ecs-network-dev-service"

vpc_id                 = "vpc-01e1cd9c8da7cb9ce"
ecs_security_group_id   = "sg-075dc2f7d79fd1d7e"

target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:597088042908:targetgroup/ecs-network-dev-tg/078bc75666ff65c4"

container_name = "app"
container_port = 8000
