#datasource to fetch myIP
data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

resource "aws_security_group" "jenkins_SG" {
  name = "jenkins-SG"
  description = "creating jenkins security group"

  # outbound rule
  egress {
    from_port   = 0 # means all port
    to_port     = 0 # means all port
    protocol    = "-1"          # means all protocol which are applicable in AWS. if you want you can define the list of protocol
    cidr_blocks = ["0.0.0.0/0"] # means allow traffic to all IP from your machine
  }

  #inbound rule
  ingress {
    description = "allow SSH"
    from_port   = 22 #accepting traffic from port 22 
    to_port     = 22 # to port 22
    protocol    = "tcp" # protocol will be accepted on tcp
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"] 
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //ipv4
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    ipv6_cidr_blocks = ["::/0"] //Specifies all IPv6 addresses, equivalent to "anywhere" in IPv6.
  }

  tags = {
    Name = "allow-levelup-ssh"
  }
}

#allow jenkins sg to communicate with sonar
resource "aws_security_group_rule" "jenkins_to_sonar" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = aws_security_group.sonar-SG.id
  source_security_group_id = aws_security_group.jenkins_SG.id
}

#allow sonar to communicate with jenkins
resource "aws_security_group_rule" "sonar_to_jenkins" {
   type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.jenkins_SG.id
  source_security_group_id = aws_security_group.sonar-SG.id
}

resource "aws_security_group" "nexus-SG" {
  name = "nexus-SG"
  description = "creating nexus security group"

  # outbound rule
  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1"          
    cidr_blocks = ["0.0.0.0/0"] 
  }

  #inbound rule
  ingress {
    description = "allow SSH"
    from_port   = 22 
    to_port     = 22 
    protocol    = "tcp" 
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"] 

  }

  ingress {
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  tags = {
    Name = "allow-levelup-ssh"
  }
}

#allow jenkins to communicate with nexus
resource "aws_security_group_rule" "jenkins_to_nexus" {
   type = "ingress"
  from_port = 8081
  to_port = 8081
  protocol = "tcp"
  security_group_id = aws_security_group.nexus-SG.id
  source_security_group_id = aws_security_group.jenkins_SG.id
}

resource "aws_security_group" "sonar-SG" {
  name = "sonar-SG"
  description = "creating sonar security group"

  # outbound rule
  egress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1"          
    cidr_blocks = ["0.0.0.0/0"] 
  }

  #inbound rule
  ingress {
    description = "allow SSH"
    from_port   = 22 
    to_port     = 22 
    protocol    = "tcp" 
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"] 

  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  tags = {
    Name = "allow-levelup-ssh"
  }
}

