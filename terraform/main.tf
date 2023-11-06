provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}
