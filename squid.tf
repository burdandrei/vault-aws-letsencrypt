resource "aws_instance" "squid" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[1]
  vpc_security_group_ids      = [aws_security_group.proxy_allow_all.id]
  user_data = base64encode(templatefile("squid.userdata.sh", {
    vpc_cidr = var.cidr
  }))

  tags = {
    Name = "${random_pet.env.id}-proxy"
  }
}
