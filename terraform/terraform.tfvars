project_name = "ecs-network"
environment  = "dev"

ecs_cluster_name = "ecs-network-dev-cluster"
ecs_service_name = "ecs-network-dev-service"

execution_role_arn = "arn:aws:iam::597088042908:role/ecs-network-dev-ecs-execution-role"
task_role_arn      = "arn:aws:iam::597088042908:role/ecs-network-dev-ecs-task-role"

ecr_repository_url = "597088042908.dkr.ecr.us-east-1.amazonaws.com/ecs-network-dev-app"

ecs_security_group_id = "sg-075dc2f7d79fd1d7e"

target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:597088042908:targetgroup/ecs-network-dev-tg/078bc75666ff65c4"

private_subnet_ids = [
  "subnet-PRIVATE-1",
  "subnet-PRIVATE-2"
]

container_name = "app"
container_port = 8000
