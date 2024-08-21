# Specify the AWS provider and region (replace with your region)
provider "aws" {
  region = "ap-south-1"  # Example region: Mumbai
}

# Create a Security Group allowing SSH and HTTP access
resource "aws_security_group" "web_sg" {
  name        = "newsg"
  description = "Allow SSH and HTTP inbound traffic"

  # Allow SSH inbound access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world (use with caution)
  }

  # Allow HTTP inbound access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch the latest Red Hat 9 AMI
data "aws_ami" "redhat9" {
  most_recent = true
  owners      = ["309956199498"]  # Red Hat's AMI owner ID for official AMIs

  filter {
    name   = "name"
    values = ["RHEL-9.*"]  # Specify Red Hat 9 AMIs
  }
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.redhat9.id  # Use the fetched Red Hat 9 AMI
  instance_type = "t2.micro"  # Free tier eligible instance
  key_name      = "mydemonew"  # Replace with your key pair name

  tags = {
    Name = "WebServer"
  }

  # User data to configure the server (install Apache HTTPD)
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              echo "<h1>Hello World from $(hostname)</h1>" > /var/www/html/index.html
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

  associate_public_ip_address = true  # Automatically assigns a public IP
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
