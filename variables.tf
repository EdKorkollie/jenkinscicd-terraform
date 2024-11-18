variable "AWS_ACCESS_KEY" {
  
}

variable "AWS_SECRET_KEY" {
  
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "JenkinsAMIS" {
  type = map(String)
  default = {
    "us-east-1" = "ami-0866a3c8686ea"
  }
}

variable "NexusAMIS" {
  type = map(String)
  default = {
    "us-east-1" = "ami-0df2a11dd1fe1f8e3"
  }
}

variable "SonarAMIS" {
  type = map(String)
  default = {
    "us-east-1" = "ami-0866a3c8686ea"
  }
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "jenkinskey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}