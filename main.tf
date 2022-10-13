resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "lab-sub"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "lab-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = "lab-rt"
  }
}

resource "aws_main_route_table_association" "rt" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.rt.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ec2" {
  key_name   = "ec2-access"
  public_key = file(var.vm_ssh_pub_key)
}

resource "random_pet" "server" {
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.your_ip]
  }

  ingress {
    description      = "SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.your_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true
  key_name = aws_key_pair.ec2.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = file("startup.sh")
  tags = {
    Name = "web-server-${random_pet.server.id}"
  }
}
