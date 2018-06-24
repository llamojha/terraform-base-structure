### Template for wipro testweb application ###
# This will create an EB for NODEJS application with rolling deployments
# with minimum 2 t2.micro instances
# in a Load Balancer listening in port 80 and instance port 80

variable "app_name"                 { default = "demo" }
variable "env"                      { default = "dev"}
variable "eb_asg_minsize"           { default = "2"}
variable "eb_asg_maxsize"           { default = "2"}
variable "eb_stack"                 { default = "64bit Amazon Linux 2017.09 v4.4.5 running Node.js"}

resource "aws_elastic_beanstalk_application" "eb-app" {
  name = "${var.app_name}"
  description = "${var.app_name} application"
}

resource "aws_elastic_beanstalk_environment" "demo-eb" {
  name                = "${var.app_name}-${var.env}"
  application         = "${var.app_name}"
  solution_stack_name = "${var.eb_stack}"

  tags {
    Name = "${var.app_name}",
    Env = "${var.env}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "50"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "${var.eb_asg_minsize}"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.eb_asg_maxsize}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "external"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  ### Setup the LoadBalancer listener port to 80
  setting {
    namespace = "aws:elb:listener:80"
    name      = "ListenerEnabled"
    value     = "true"
  }

  ### setup the LoadBalancer instance port to 80
  setting {
    namespace = "aws:elb:listener:80"
    name      = "InstancePort"
    value     = "80"
  }
}

### return the DNS record for the EB
output "eb-dns-record" {
  value = "${aws_elastic_beanstalk_environment.demo-eb.cname}"
}
