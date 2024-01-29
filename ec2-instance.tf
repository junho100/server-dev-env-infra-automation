################################################################################
# EC2 Module
################################################################################

module "bastion_host" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = format(module.naming.result, "bastion-host-ec2")

  ami                         = "ami-0b23bb3616e3892a6"
  instance_type               = "t3.micro"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.sg_for_bastion_host.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false

  key_name = aws_key_pair.key_pair_for_bastion_host.key_name
}

module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = format(module.naming.result, "backend-ec2")

  ami                         = "ami-0b23bb3616e3892a6"
  instance_type               = "t3.medium"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group_for_backend.security_group_id]
  associate_public_ip_address = false
  disable_api_stop            = false

  key_name = aws_key_pair.key_pair_for_backend.key_name

  iam_instance_profile = module.backend_instance_role.iam_instance_profile_name
}

################################################################################
# Supporting Resources
################################################################################

resource "tls_private_key" "private_key_for_bastion_host" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair_for_bastion_host" {
  key_name   = format(module.naming.result, "bastion-host-key")
  public_key = tls_private_key.private_key_for_bastion_host.public_key_openssh
}

resource "tls_private_key" "private_key_for_backend" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair_for_backend" {
  key_name   = format(module.naming.result, "backend-key")
  public_key = tls_private_key.private_key_for_backend.public_key_openssh
}
