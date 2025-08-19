# key pair login 

resource aws_key_pair my_key{
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
} 

#vpc & security group

resource aws_default_vpc deafult {
  
}

resource aws_security_group my_security_group {
    name = "automate-sg"
    description = "this will add a TF genrated Security group"
    vpc_id  = aws_default_vpc.deafult.id #interpolation

#inbound rule 

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "open SSH"
}

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "internet"
}

ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "internet"
}

ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask App"
}

#outbound rule 

egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
}


tags = {
    name = "automate-sg"
}
}

#ec2

resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    ami = "ami-00ca32bbc84273381" #ubuntu
    instance_type = "t2.micro"
    
    root_block_device {
        volume_size = 15
        volume_type = "gp3"
    }
    tags = {
        name = "terra-in-coding-automate"
    }
}
