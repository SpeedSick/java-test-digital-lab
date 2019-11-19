
variable "ssh_public_key" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "instance_type" {
  description = "instance type for K8s creation Server - Eg:t2.micro"
}

variable "instance_ami" {
  description = "AMI for Instance"
}

variable "instance_key" {
  description = "Key for k8s Server"
}

variable "server-name" {}

variable "k8-subnet" {
  type = ""
}

resource "aws_security_group" "kubernetes-server-instance-sg" {
  name        = "kubernetes-server-instance-sg"
  description = "kubectl_instance_sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "kubectl_server-SG"
  }
}

resource "aws_instance" "kubernetes-server" {
  instance_type          = "${var.instance_type}"
  ami                    = "${var.instance_ami}"
  key_name               = "${var.instance_key}"
  subnet_id              = "${var.k8-subnet}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-server-instance-sg.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  tags {
    Name = "${var.server-name}"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.kubernetes-server.id}"
  vpc      = true

  tags = {
    Name = "server_eip"
  }
}

output "elastic_ip" {
  value = "${aws_eip.ip.public_ip}"
}

output "kubernetes-server-instance-sg" {
  value = "${aws_security_group.kubernetes-server-instance-sg.id}"
}