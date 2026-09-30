provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

variable "ssh_key_path" {
  type = string
}
resource "aws_instance" "machine-1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = "devops-keys"
  user_data     = <<-EOF
                  #!/bin/bash
                    echo "OKAY MICHAEL WE ARE HERE" > /tmp/note.txt
                    EOF   
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]


    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.ssh_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "TF-machine-1"
  }

}
