locals {
  endpoint_subnets = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id
  ]
}

# S3 Gateway endpoint -> associato alle 2 RT private (app + db)
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = aws_vpc.p2.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [
    aws_route_table.rt_app_private.id,
    aws_route_table.rt_db_private.id
  ]

  tags = { Name = "gateway-endpoints" }
}

# Interface endpoints: SSM, SSMMessages, EC2Messages su 2 subnet (app-a/app-b)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.p2.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  subnet_ids          = local.endpoint_subnets
  security_group_ids  = [aws_security_group.sgendpoints.id]
  private_dns_enabled = true
  tags = { Name = "endpoint-ssm" }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.p2.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  subnet_ids          = local.endpoint_subnets
  security_group_ids  = [aws_security_group.sgendpoints.id]
  private_dns_enabled = true
  tags = { Name = "endpoint-ssm-message" }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.p2.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  subnet_ids          = local.endpoint_subnets
  security_group_ids  = [aws_security_group.sgendpoints.id]
  private_dns_enabled = true
  tags = { Name = "endpoint-EC2" }
}
