resource "aws_key_pair" "jenkins_keypair" {
  key_name = "jenkinskey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "jenkinsServer" {
  ami = lookup(var.JenkinsAMIS, var.AWS_REGION)

  key_name = aws_key_pair.jenkins_keypair

  instance_type = "t2.small"

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexusServer" {
  ami = lookup(var.NexusAMIS, var.AWS_REGION)

  key_name = aws_key_pair.jenkins_keypair

  instance_type = "t2.medium"

  tags = {
    Name = "nexus-server"
  }
}

resource "aws_instance" "sonarServer" {
  ami = lookup(var.SonarAMIS, var.AWS_REGION)

  key_name = aws_key_pair.jenkins_keypair

  instance_type = "t2.medium"

  tags = {
    Name = "sonar-server"
  }
}

