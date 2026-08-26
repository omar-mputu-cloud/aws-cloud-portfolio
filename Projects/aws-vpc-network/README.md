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