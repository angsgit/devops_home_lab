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


# --- Create a Security Group for K8s Cluster ---

resource "aws_security_group" "main_sg" {
  name        = "k8s-cluster-sg"
  description = "Allow Kubernetes cluster communication + SSH + HTTP"
  vpc_id      = aws_vpc.main.id

  # --- Allow SSH from anywhere (for simplicity) ---
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Allow HTTP traffic for app access ---
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Allow K8s API Server (kubectl access) ---
  ingress {
    description = "Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Allow K8s node-to-node communication (intra-cluster) ---
  ingress {
    description = "Kubernetes node communication"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Allow pods & services (K8s internal networking) ---
  ingress {
    description = "Kubernetes pods & services"
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- Allow all outbound traffic ---
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-cluster-sg"
  }
}


# --- CREATE K8S CLUSTER ---

# --- Kubernetes Control Plane Node ---
resource "aws_instance" "k8s_master" {
  ami                    = "ami-0bc691261a82b32bc" # Ubuntu 22.04 LTS (eu-west-1)
  instance_type          = "t3.medium"
  key_name               = "angs-key"
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "aws-k8s-master"
    Role = "master"
  }
}

# --- Kubernetes Worker Node 1 ---
resource "aws_instance" "k8s_worker1" {
  ami                    = "ami-0bc691261a82b32bc"
  instance_type          = "t3.medium"
  key_name               = "angs-key"
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "aws-k8s-worker1"
    Role = "worker"
  }
}

# --- Kubernetes Worker Node 2 ---
resource "aws_instance" "k8s_worker2" {
  ami                    = "ami-0bc691261a82b32bc"
  instance_type          = "t3.medium"
  key_name               = "angs-key"
  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "aws-k8s-worker2"
    Role = "worker"
  }
}

