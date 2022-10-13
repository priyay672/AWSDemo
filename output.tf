output "vpc_id" {
   value = ["${aws_vpc.main.id}"]
}

output "aws_subnet" {
   value = ["${aws_subnet.main.id}"]
}

output "webserver_id" {
   value = ["${aws_instance.web.id}"]
}

output "ip_addresses" {
   value = ["${aws_instance.web.public_ip}"]
}
