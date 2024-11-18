resource "aws_key_pair" "jenkins_keypair" {
  key_name = "jenkinskey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "jenkinsServer" {
  ami = lookup(var.JenkinsAMIS, var.AWS_REGION)

  key_name = aws_key_pair.jenkins_keypair

  instance_type = "t2.small"

  provisioner "file" {
    source = "installjenkins.sh"
    destination = "/tmp/installjenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x/tmp/installjenkins.sh",
        "sudo sed -i -e 's/\r$//' /tmp/installjenkins.sh",
        "sudo /tmp/installjenkins.sh" 
     ]
  }

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexusServer" {
  ami = lookup(var.NexusAMIS, var.AWS_REGION)

  key_name = aws_key_pair.jenkins_keypair

  instance_type = "t2.medium"

  provisioner "file" {
    source = "installnexus.sh"
    destination = "/tmp/installnexus.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x/tmp/installnexus.sh",
        "sudo sed -i -e 's/\r$//' /tmp/installnexus.sh",
        "sudo /tmp/installnexus.sh" 
     ]
  }

  tags = {
    Name = "nexus-server"
  }
}

resource "aws_instance" "sonarServer" {
  ami = lookup(var.SonarAMIS, var.AWS_REGION)

  key_name = aws_key_pair.jenkins_keypair

  instance_type = "t2.medium"
  
  provisioner "file" {
    source = "installsonar.sh"
    destination = "/tmp/installsonar.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x/tmp/installsonar.sh",
        "sudo sed -i -e 's/\r$//' /tmp/installsonar.sh",
        "sudo /tmp/installsonar.sh" 
     ]
  }

  tags = {
    Name = "sonar-server"
  }
}

output "public_ip" {
  value = [aws_instance.jenkinsServer, aws_instance.nexusServer, aws_instance.sonarServer]
}


