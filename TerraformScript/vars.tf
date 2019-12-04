variable "aws_region"{
  default = "eu-west-1"
}

variable "aws_access_key"{
  default = ""
}

variable "aws_secret_key"{
  default = ""
}

variable "bucketName"{
  default = ""
}

provider "aws"{
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

variable "priority"{

  // add in the P1 priority ID
  default = ""
}

variable "users" {

  // add in the users first part of their email e.g. hliang@pagerduty.com would be hliang
  type = list
  default = ["hliang", "tchinchen"]
}

variable "name" {

  // add in users first name, make sure the list follows the same order as above
  type = list
  default = ["Hao-lin", "Tim" ]

}


provider "pagerduty"{

  //PD Api token
  token = ""
}

