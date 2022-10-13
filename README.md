## Instructions

This is working deployment of very simple nginx-powered static site.
To deploy it, you'll need:
- Terraform installed on your computer (tested on v1.3.1)
- AWS account, assumption is you are the owner of the project and can grant yourself all priviliges
- SSH key pair for VM access
- Provide all of the variable values as defined in variables.tf (you can put them into terraform.tfvars)
- Run: terraform init, plan, apply

If deployment completes successfully, you should be able to reach your VM in web browser: http://your-vm-public-ip-addr/ and see something like this:
![Screenshot](img/whatyoushouldsee.png)
You should also be able to ssh into it.
