resource "aws_instance" "api_gateway" {
  ami                    = var.ami
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.api_gateway.id]
  key_name               = aws_key_pair.deployer.key_name
  tags = { Name = "api-gateway" }
}

resource "aws_instance" "caller_worker" {
  ami                    = var.ami
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.workers.id]
  key_name               = aws_key_pair.deployer.key_name
  tags = { Name = "caller-worker" }
}

resource "aws_instance" "inference_worker" {
  ami                    = var.ami
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.workers.id]
  key_name               = aws_key_pair.deployer.key_name
  root_block_device {
    volume_size = 20
  }
  tags = { Name = "inference-worker" }
}

output "api_gateway_public_ip" {
  value = aws_instance.api_gateway.public_ip
}
output "caller_worker_private_ip" {
  value = aws_instance.caller_worker.private_ip
}
output "inference_worker_private_ip" {
  value = aws_instance.inference_worker.private_ip
}