
resource "aws_vpc" "kubeflow_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "suu-kubeflow-project"
  }
}

resource "aws_security_group" "allow_access" {
  name        = "allows_access_to_ec2"
  description = "Allow any inbound traffic"
  vpc_id      = aws_vpc.kubeflow_vpc.id

  ingress {
    description      = "Allow access"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_access_kubeflow"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.kubeflow_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.kubeflow_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_internet_gateway" "suu_kubeflow_main_gateway" {
  vpc_id = aws_vpc.kubeflow_vpc.id

  tags = {
    Name = "suu-kubeflow-project"
  }
}

resource "aws_route_table" "stream_graph_rt_public" {
  vpc_id = aws_vpc.kubeflow_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.suu_kubeflow_main_gateway.id
  }
}

resource "aws_main_route_table_association" "route_tab_assoc" {
  vpc_id         = aws_vpc.kubeflow_vpc.id
  route_table_id = aws_route_table.stream_graph_rt_public.id
}