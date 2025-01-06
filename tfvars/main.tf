resource "aws_security_group" "allow_ssh" {

    name = "allow-ssh-${var.environment}"
    description = "allow ssh on port 22 for ingress traffic"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = merge(
        var.common_tags,
        var.tags,
        {
            Name = "allow-ssh-${var.environment}"
        }
    )
  
}

resource "aws_instance" "expense-environment" {
    for_each = var.instances
    ami = data.aws_ami.ami_info.id
    vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
    instance_type = each.value

    tags = merge(
        var.common_tags,
        var.tags,
        {
            Name = each.key
        }
    )
  
}
resource "aws_route53_record" "expense_dns_records" {
    for_each = aws_instance.expense-environment
  zone_id = var.zone_id
  name    = each.key == "frontend-prod" ? var.domain_name : "${each.key}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = each.key == "frontend-prod" ? [each.value.public_ip] : [each.value.private_ip]
}