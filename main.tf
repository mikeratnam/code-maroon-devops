terraform {
  backend "s3" {
    bucket = "code-maroon-tfstate-1-540393117528-ap-south-1-an"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

variable "ssh_key_path" {
  type = string
}
resource "aws_instance" "machine-1" {
  ami           = "ami-04cda0421f6ffa675"
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
      host        = self.private_ip
    }
  }

  tags = {
    Name = "TF-machine-1"
  }

}
