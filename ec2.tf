resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH from Whitelist"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.whitelist_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "benchmark_sg" {
  name   = "benchmark-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "benchmark-sg"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${var.keypair_path}")
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "ssm-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "ssm_policy" {
  name = "ssm_policy"
  role = aws_iam_role.ssm_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssmmessages:*",
        "ssm:UpdateInstanceInformation",
        "ec2messages:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-profile"
  role = aws_iam_role.ssm_role.name
}

data "aws_subnet" "benchmark_subnet" {
  filter {
    name   = "availability-zone"
    values = [aws_db_instance.postgresql_saz.availability_zone]
  }
  filter {
    name   = "tag:type"
    values = ["private"]
  }
}

resource "aws_instance" "benchmark" {
  # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.benchmark_instance_class
  subnet_id              = data.aws_subnet.benchmark_subnet.id
  vpc_security_group_ids = [aws_security_group.benchmark_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  key_name = aws_key_pair.deployer.key_name

  user_data = templatefile("${path.module}/templates/ec2-userdata-tpl.sh", {
    aurora_writer_endpoint = aws_rds_cluster.aurora_cluster.endpoint
    rds_maz_endpoint       = aws_db_instance.postgresql_maz.address
    rds_saz_endpoint       = aws_db_instance.postgresql_saz.address
    database_username      = var.database_username
    database_password      = var.database_password
    database_name          = var.database_name
  })

  tags = {
    Name = "benchmark"
  }
}

resource "aws_instance" "bastion" {
  # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.bastion_instance_class
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "bastion"
  }
}
