variable "region" {
    description = "aws region"
    #default = "eu-central-1"
}

variable "vm_ssh_pub_key" {
    description = "Public ssh key value - for vm access"
    #default = "ssh_keys/priya.pub"
}

variable "your_ip" {
    description = "Your IP address, CIDR format"
    #default = "78.9.137.250/32"
}
