module "qa_ec2" {
  source = "../../modules/ec2"

  environment   = "QA"
  instance_type = "t3.micro"
  ami_id        = "ami-0c55b159cbfafe1f0"
}

user_data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
