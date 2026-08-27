# AWS VPC Network Project

## Project Overview

This project demonstrates the design and deployment of a custom AWS Virtual Private Cloud (VPC) using the AWS CLI.

The network was designed with public and private subnets distributed across two Availability Zones to provide network segmentation and a foundation for highly available AWS workloads.

## Architecture

- VPC CIDR: `10.0.0.0/16`
- Region: `us-east-1`
- Availability Zones: `us-east-1a` and `us-east-1b`
- 2 Public Subnets
- 2 Private Subnets
- Internet Gateway
- Public Route Table
- Private Route Table

## Subnet Design

| Subnet | CIDR | Availability Zone | Public IPv4 |
|---|---|---|---|
| Public Subnet 1 | `10.0.1.0/24` | `us-east-1a` | Enabled |
| Public Subnet 2 | `10.0.2.0/24` | `us-east-1b` | Enabled |
| Private Subnet 1 | `10.0.11.0/24` | `us-east-1a` | Disabled |
| Private Subnet 2 | `10.0.12.0/24` | `us-east-1b` | Disabled |

## Routing

The public subnets are associated with a public route table containing a default route (`0.0.0.0/0`) to the Internet Gateway.

The private subnets use a separate private route table with only the VPC local route. No direct route from the private route table to the Internet Gateway was configured.

## Tools Used

- Amazon Web Services (AWS)
- AWS CLI
- IAM Identity Center / AWS SSO
- Amazon VPC
- Git
- GitHub
- Visual Studio Code

## Skills Demonstrated

- VPC and subnet design
- CIDR addressing
- Public and private network segmentation
- Multi-Availability Zone architecture
- Internet Gateway configuration
- Route table creation and association
- AWS CLI resource deployment
- AWS resource tagging
- Infrastructure verification using AWS CLI
- Git and GitHub documentation workflow
## EC2 Web Server Deployment

An Amazon EC2 instance was deployed into Public Subnet 1 to validate internet connectivity through the custom VPC.

### EC2 Configuration

- Operating System: Amazon Linux 2023
- Instance Type: `t3.micro`
- Subnet: Public Subnet 1 (`10.0.1.0/24`)
- Availability Zone: `us-east-1a`
- Public IPv4 Address: Enabled
- Security Group: `aws-portfolio-web-sg`

### Security Group

The web server security group allows inbound HTTP traffic:

| Protocol | Port | Source | Purpose |
|----------|------|--------|---------|
| TCP | 80 | `0.0.0.0/0` | Public HTTP access |

### Automated Web Server Configuration

EC2 User Data was used to automatically install and configure Apache during instance initialization.

```bash
#!/bin/bash
dnf install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1>My AWS Cloud Portfolio</h1><p>Day 3 - EC2 Web Server running in my custom VPC.</p>" > /var/www/html/index.html

## Day 4 - Private EC2, NAT Gateway, and Systems Manager

Day 4 extended the VPC architecture by deploying an EC2 instance into a private subnet and providing secure outbound Internet connectivity through an AWS NAT Gateway.

The private EC2 instance was intentionally deployed without a public IPv4 address.

### Private EC2 Configuration

- Operating System: Amazon Linux 2023
- Instance Type: `t3.micro`
- Private Subnet: `10.0.11.0/24`
- Private IPv4 Address: `10.0.11.214`
- Public IPv4 Address: None
- Security Group: `aws-portfolio-private-sg`

### NAT Gateway

A NAT Gateway was deployed in Public Subnet 1 to provide outbound Internet access for resources in the private subnet.

The private route table contains the following routes:

| Destination | Target | Purpose |
|---|---|---|
| `10.0.0.0/16` | local | Communication within the VPC |
| `0.0.0.0/0` | NAT Gateway | Outbound Internet access |

This design allows the private EC2 instance to initiate connections to the Internet without accepting direct inbound Internet connections.

### Systems Manager Session Manager

AWS Systems Manager Session Manager was configured to securely administer the private EC2 instance without assigning it a public IP address or opening inbound SSH port 22.

An IAM role was created with the AWS-managed policy:

`AmazonSSMManagedInstanceCore`

The role was attached to an EC2 instance profile and associated with the private instance.

The instance successfully registered with Systems Manager with a `PingStatus` of `Online`.

### Connectivity Validation

Outbound connectivity from the private EC2 instance was tested through an SSM Session Manager shell.

The command:

```bash
curl https://checkip.amazonaws.com
```

returned the Elastic IP address assigned to the NAT Gateway, confirming that outbound traffic from the private instance was being translated through the NAT Gateway.

Repository connectivity was also validated using:

```bash
dnf check-update
```

The instance successfully reached the Amazon Linux 2023 repositories.

### Architecture Flow

```text
Private EC2 Instance
10.0.11.214
No Public IP
        |
        v
Private Subnet
        |
        v
Private Route Table
0.0.0.0/0 -> NAT Gateway
        |
        v
NAT Gateway
Public Subnet
        |
        v
Internet Gateway
        |
        v
Internet
```

### Security Design

This architecture demonstrates several AWS security best practices:

- Workloads in private subnets do not require public IP addresses.
- Outbound Internet connectivity is provided through a NAT Gateway.
- Direct inbound Internet access to the private EC2 instance is prevented.
- Administrative access is provided through AWS Systems Manager Session Manager.
- SSH port 22 does not need to be exposed to the Internet.
- EC2 permissions are provided through an IAM role rather than long-term credentials.

### Skills Demonstrated

- AWS VPC public and private subnet architecture
- NAT Gateway deployment
- Elastic IP allocation
- Private route table configuration
- EC2 deployment without a public IP address
- IAM roles and instance profiles
- AWS Systems Manager Session Manager
- Secure administration without SSH
- AWS CLI networking configuration and validation
- Troubleshooting private-instance Internet connectivity