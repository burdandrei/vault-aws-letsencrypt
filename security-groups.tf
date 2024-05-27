# Default Security group
resource "aws_security_group" "allow_tls" {
  name        = "${random_pet.env.id}_allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${random_pet.env.id}-allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_vtls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8200
  ip_protocol       = "tcp"
  to_port           = 8201
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# End of default security group


# Airgapped Security group
resource "aws_security_group" "vault_airgapped" {
  name        = "${random_pet.env.id}_airgapped"
  description = "Allow inbound traffic and restrict all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${random_pet.env.id}-airgap"
  }
}


resource "aws_vpc_security_group_ingress_rule" "airgapped_allow_ssh" {
  security_group_id = aws_security_group.vault_airgapped.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_ingress_rule" "airgapped_allow_tls_ipv4" {
  security_group_id = aws_security_group.vault_airgapped.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "airgapped_allow_vtls_ipv4" {
  security_group_id = aws_security_group.vault_airgapped.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8200
  ip_protocol       = "tcp"
  to_port           = 8201
}

resource "aws_vpc_security_group_ingress_rule" "airgapped_allow_tls_ipv6" {
  security_group_id = aws_security_group.vault_airgapped.id
  cidr_ipv6         = module.vpc.vpc_ipv6_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "airgapped_allow_vpc_traffic_ipv4" {
  security_group_id = aws_security_group.vault_airgapped.id
  cidr_ipv4         = var.cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Proxy Allow ALl Security group
resource "aws_security_group" "proxy_allow_all" {
  name        = "${random_pet.env.id}_proxy"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "${random_pet.env.id}-proxy"
  }
}


resource "aws_vpc_security_group_ingress_rule" "proxy_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.proxy_allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "proxy_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.proxy_allow_all.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "proxy_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.proxy_allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "proxy_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.proxy_allow_all.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
