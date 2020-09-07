#!/bin/bash
# please replace the actual key path below
ssh -i <path/to/key.pem> -o ProxyCommand="ssh -i <path/to/key.pem> -W %h:%p ec2-user@$(terraform output bastion_endpoint)" ec2-user@$(terraform output benchmark_endpoint)
