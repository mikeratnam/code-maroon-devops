resource "aws_instance" "instance_one" {
  ami           = "var.ami_id"
  instance_type = "var.instance_type"
  user_data     = <<-EOF
                  #!/bin/bash
                    echo "Hello, World!" > index.html
                    nohup python -m SimpleHTTPServer 80 &
                    EOF                

  tags = {
    Name        = " $(var.environment)-server"
    Environment = var.environment
  }
}
