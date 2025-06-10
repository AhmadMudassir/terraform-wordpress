
# 🚀 Terraform WordPress on AWS

This project provisions a complete WordPress setup on AWS using Terraform. It automates the creation of a Virtual Private Cloud (VPC), subnet, security groups, and an EC2 instance, then installs WordPress using a user-data script.

---

## 📸 Architecture Overview

![VPC-Wordpress](https://github.com/user-attachments/assets/c4cb28d1-5d84-4bdc-b39a-5476bce55be7)

---

## 📌 Project Objective

Provision an EC2 instance on AWS using Terraform, install WordPress with MySQL on the instance, and configure it—all using an automated user-data script.

---

## 📁 Repository Structure

```
.
├── main.tf             # Main Terraform configuration for AWS infrastructure
├── variables.tf        # Input variables for Terraform
├── outputs.tf          # Outputs like EC2 public IP
├── user-data.sh        # User-data script to install and configure WordPress
├── README.md           # Project documentation
├── .gitignore
└── .terraform.lock.hcl
```

---

## 🛠️ Features

- ✅ Creates a VPC with custom CIDR block
- ✅ Launches an EC2 instance in a public subnet
- ✅ Attaches an Internet Gateway and configures routing
- ✅ Sets up Security Groups to allow HTTP (80), SSH (22)
- ✅ Installs Apache, PHP, MySQL, and WordPress automatically
- ✅ Sets up a WordPress database and configuration
- ✅ Securely fetches database password from AWS Secrets Manager
- ✅ Outputs EC2 instance public IP after provisioning

---

## ⚙️ Technologies Used

- **Terraform**
- **AWS EC2, VPC, Subnet, Security Group**
- **Apache2, PHP, MySQL**
- **WordPress**
- **AWS Secrets Manager**

---

## 📦 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- AWS CLI configured (`aws configure`)
- A valid AWS key pair
- Sufficient IAM permissions to provision infrastructure
- A secret in AWS Secrets Manager containing the DB password

---

## 📌 Default Configuration

| Variable             | Default Value              | Description                        |
|----------------------|----------------------------|------------------------------------|
| `region`             | `us-east-2`                | AWS region                         |
| `ami`                | `ami-004364947f82c87a0`    | Ubuntu-based AMI                   |
| `type`               | `t2.micro`                 | EC2 instance type                  |
| `keypair`            | `your-keypair-name`        | Existing AWS key pair name         |
| `vpc-cidr`           | `10.0.0.0/16`              | CIDR block for the VPC             |
| `subnet-cidr`        | `10.0.1.0/24`              | CIDR block for the public subnet   |
| `all-traffic-cidr`   | `0.0.0.0/0`                | Open to all traffic (demo only)    |

---

## 🚀 How to Deploy

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/terraform-wordpress.git
   cd terraform-wordpress
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the execution plan**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Note the EC2 public IP**
   - Terraform outputs it automatically.

6. **Access WordPress**
   - Open a browser and go to `http://<public-ip>`

---

## 🔐 AWS Secrets Manager Integration

This setup includes secure handling of database credentials using AWS Secrets Manager.

### 🧾 Secret Details

- Store your DB password in Secrets Manager under a name like `wordpress/creds`
- Example secret JSON:
```json
{
  "dbpass": "your-secure-password"
}
```

### ⚙️ IAM Role

An IAM role with `secretsmanager:GetSecretValue` and `secretsmanager:DescribeSecret` permissions is attached to the EC2 instance to fetch the password.

---

## 🛡️ Security Group Rules

| Port | Purpose     | Source      |
|------|-------------|-------------|
| 22   | SSH Access  | 0.0.0.0/0   |
| 80   | HTTP Access | 0.0.0.0/0   |

> ⚠️ Consider restricting access in production environments.

---

## 📜 User Data Script Summary

The `user-data.sh` script does the following:

- Installs Apache, PHP, and MySQL
- Downloads and configures WordPress
- Installs AWS CLI and `jq`
- Fetches database password securely from AWS Secrets Manager
- Sets up WordPress database and user with the secret
- Applies necessary Apache configurations
- Injects WordPress security salts
- Starts necessary services

---

## 🧹 Teardown

To remove all provisioned resources:

```bash
terraform destroy
```

---

## ✅ Verification

After setup:

- Navigate to the public IP in a browser
- You should see the WordPress setup screen
- Follow the instructions to complete installation

---

## 📬 Outputs

- **VPC ID**
- **Subnet ARN**
- **EC2 Public IP**

Example:

```bash
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

ec2-public-ip = "3.22.44.11"
public_subnet_arn = "arn:aws:ec2:us-east-2:..."
vpc_id = "vpc-0f4a3..."
```

---

## 📎 To-Do / Future Improvements

- Add support for RDS instead of local MySQL
- Add HTTPS with Let's Encrypt
- Add autoscaling or load balancing
- Improve security with limited CIDRs

---

## 👤 Author

**Ahmad** – Infrastructure Automation Enthusiast  
[GitHub](https://github.com/your-username)

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).
