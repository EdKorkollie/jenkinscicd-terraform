resource "aws_key_pair" "jenkins_keypair" {
  key_name = "jenkinskey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "jenkinsServer" {
  ami = "ami-0866a3c8686eaeeba"

  key_name = aws_key_pair.jenkins_keypair.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_SG.id]

  instance_type = "t2.small"

  provisioner "file" {
    source = "installjenkins.sh"
    destination = "/tmp/installjenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/installjenkins.sh",
        "sudo sed -i -e 's/\r$//' /tmp/installjenkins.sh",
        "sudo /tmp/installjenkins.sh" 
     ]
  }

  connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = var.INSTANCE_USERNAME
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "nexusServer" {
  ami = "ami-0df2a11dd1fe1f8e3"

  key_name = aws_key_pair.jenkins_keypair.key_name
  vpc_security_group_ids = [aws_security_group.nexus-SG.id]

  instance_type = "t2.medium"

  provisioner "file" {
    source = "installnexus.sh"
    destination = "/tmp/installnexus.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/installnexus.sh", 
        "sudo sed -i -e 's/\r$//' /tmp/installnexus.sh", 
        "sudo /tmp/installnexus.sh"
     ]
  }

   connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = var.NEXUSINSTANCE_USERNAME
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

  tags = {
    Name = "nexus-server"
  }
}

resource "aws_instance" "sonarServer" {
  ami = "ami-0866a3c8686eaeeba"

  key_name = aws_key_pair.jenkins_keypair.key_name
  vpc_security_group_ids = [aws_security_group.sonar-SG.id]

  instance_type = "t2.medium"
  
  provisioner "file" {
    source = "installsonar.sh"
    destination = "/tmp/installsonar.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/installsonar.sh", # provide the executable permission to this file
        "sudo sed -i -e 's/\r$//' /tmp/installsonar.sh", # Remove the spurious CR characters
        "sudo /tmp/installsonar.sh"
     ]
  }

   connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = var.INSTANCE_USERNAME
      private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

  tags = {
    Name = "sonar-server"
  }
}

output "public_ip" {
  value = [aws_instance.jenkinsServer, aws_instance.nexusServer, aws_instance.sonarServer]
}


