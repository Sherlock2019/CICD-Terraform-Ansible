provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "GitHub-Action-EC2"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
terraform output -json > inventory.json

}
