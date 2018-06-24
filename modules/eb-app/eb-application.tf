variable "app-name"  { }

resource "aws_elastic_beanstalk_application" "eb-app" {
  name = "${var.app-name}"
  description = "${var.app-name} application"
}

output "app-id" {
  value = "${aws_elastic_beanstalk_application.eb-app.name}"
}