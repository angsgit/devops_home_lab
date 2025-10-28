# --- Create a VPC ---
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

# --- Create a Subnet ---
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true #auto assign public IP at lunch

  tags = {
    Name = "terraform-subnet"
  }
}

# --- Create an Internet Gateway ---
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-igw"
  }
}

# --- Create a Route Table and Associate it ---
resource "aws_route_table" "main_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "terraform-rtb"
  }
}

resource "aws_route_table_association" "main_rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rtb.id
}

# --- Create a Security Group ---
resource "aws_security_group" "main_sg" {
  name        = "terraform-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}

# --- Create EC2 Instance ---
resource "aws_instance" "test_vm" {
  ami           = "ami-0bc691261a82b32bc" # Ubuntu 22.04 LTS (eu-west-1)
  instance_type = "t2.micro"
  key_name      = "angs-key"

  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "terraform-test-vm"
  }
}
