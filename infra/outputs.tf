output "vpc_id" { value = aws_vpc.p2.id }

output "vpc_endpoints" {
  value = {
    s3_gateway  = aws_vpc_endpoint.s3_gateway.id
    ssm         = aws_vpc_endpoint.ssm.id
    ssmmessages = aws_vpc_endpoint.ssmmessages.id
    ec2messages = aws_vpc_endpoint.ec2messages.id
  }
}
