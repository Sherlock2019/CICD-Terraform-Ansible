# CICD-Terraform-Ansible
CiCd github actions using IAC ansible Terraform for deployment
 scenario that integrates Ansible, Ansible Tower, and Terraform within a company's operations:

    Company Profile:

-   Name:   TechSolutions Inc.
-   Industry:   Software Development and IT Services
-   Infrastructure:   Hybrid Cloud (AWS and On-Premises Data Centers)
-   Current Setup:   Infrastructure as Code (IaC) managed with Terraform for provisioning. Need for configuration management and automation for deployment and operations.

    Scenario:

TechSolutions Inc. has been using Terraform to successfully provision their cloud and on-premises infrastructure. However, as their operations have grown, they've encountered challenges with configuration management, application deployment, and operational tasks across their diverse environments.

They need a solution that can:

1. Manage configurations across multiple environments.
2. Automate application deployments.
3. Orchestrate complex operational workflows.
4. Provide role-based access control and auditing capabilities.

    Solution:

   # Ansible:

-   Role:   Configuration Management and Application Deployment
-   Use Case:  
  -   Configuration Management:   Ansible playbooks are written to manage the configuration of servers provisioned by Terraform. This includes setting up required services, users, and system settings.
  -   Application Deployment:   Ansible is used to automate the deployment of applications across various environments. It ensures that the latest codebase is pulled from the version control system, dependencies are installed, and the application is started with the correct configurations.

   # Ansible Tower:

-   Role:   Automation Orchestration, Access Control, and Auditing
-   Use Case:  
  -   Workflow Orchestration:   Ansible Tower orchestrates complex workflows that involve multiple Ansible playbooks. For example, after Terraform provisions a new set of servers, Ansible Tower triggers Ansible to configure these servers and deploy applications.
  -   Role-Based Access Control (RBAC):   Ansible Tower provides RBAC to manage who can run certain playbooks, access credentials, and manage inventories, ensuring compliance with company policies.
  -   Auditing and Compliance:   Ansible Tower logs all automation jobs, providing an audit trail for changes made to the infrastructure. This is crucial for compliance with industry regulations.

    Implementation Scenario:

1.   Provisioning Phase:  
   - Terraform scripts are executed to provision new infrastructure on AWS and update the on-premises setup.
   - Terraform outputs the inventory of the new resources, which is then fed into Ansible Tower.

2.   Configuration and Deployment Phase:  
   - Ansible Tower picks up the new inventory and executes Ansible playbooks to configure the servers according to their roles (web servers, database servers, etc.).
   - Once configured, Ansible playbooks deploy the latest version of the applications onto the appropriate servers.

3.   Operational Workflows:  
   - Ansible Tower schedules and runs operational workflows, such as database backups, log rotation, and security patching, across the entire infrastructure.
   - Developers and operations teams have access to self-service portals in Ansible Tower to launch predefined playbooks for routine tasks without needing direct access to the servers.

4.   Monitoring and Reporting:  
   - Ansible Tower monitors the execution of all playbooks and provides reports on the state of the infrastructure and applications.
   - In case of any failures, Ansible Tower alerts the operations team and can automatically execute remediation playbooks to fix known issues.

    Conclusion:

By integrating Ansible and Ansible Tower with their existing Terraform setup, TechSolutions Inc. can achieve a higher level of automation, better compliance, and a more efficient way to manage their growing infrastructure. This integration allows them to maintain agility, enforce security standards, and reduce manual overhead, leading to a more reliable and scalable operational environment.



B/  the Step by step  implementation with code 


Let's break down the scenario into detailed steps with code examples for someone who is new to Terraform and Ansible. We'll go through the process of provisioning an AWS EC2 instance with Terraform, configuring it with Ansible, and managing the workflow with Ansible Tower.


    Step 1: Provisioning Infrastructure with Terraform

Terraform is an Infrastructure as Code tool that allows you to define resources and infrastructure in configuration files that can be versioned, reused, and shared.

  1.1 Install Terraform:  

- Download Terraform from the [official website](https://www.terraform.io/downloads.html).
- Unzip the package and place the Terraform binary in a directory included in your system's PATH.

  1.2 Write Terraform Configuration:  

Create a file named `main.tf` with the following content:

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}
```

This configuration tells Terraform to create an AWS EC2 instance in the `us-west-2` region with a given AMI and instance type.

  1.3 Initialize Terraform:  

Run the following command in the directory where your `main.tf` file is located:

```sh
terraform init
```

This command initializes Terraform, downloads the AWS provider, and prepares your directory for other Terraform commands.

  1.4 Apply Terraform Configuration:  

Execute the following command to create the infrastructure:

```sh
terraform apply
```

You'll be prompted to confirm the action. Once confirmed, Terraform will provision the EC2 instance as defined.

  1.5 Output Instance Information:  

Add the following to your `main.tf` to output the public IP of the instance:

```hcl
output "web_instance_ip" {
  value = aws_instance.web.public_ip
}
```

After applying the configuration, Terraform will display the public IP of the provisioned instance.

    Step 2: Configuring the Instance with Ansible

Ansible is a configuration management tool that uses playbooks to automate the deployment and configuration of servers.

  2.1 Install Ansible:  

Follow the installation guide on the [official Ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

  2.2 Write Ansible Playbook:  

Create a file named `playbook.yml` with the following content:

```yaml
- hosts: all
  become: yes
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
      when: ansible_os_family == "Debian"

    - name: Install Apache
      apt:
        name: apache2
        state: present
      when: ansible_os_family == "Debian"

    - name: Copy index.html
      copy:
        content: "Hello, World!"
        dest: /var/www/html/index.html
```

This playbook will update the package cache, install Apache, and create a simple `index.html` file on Debian-based systems.

  2.3 Create Inventory File:  

Ansible needs an inventory file to know which servers to manage. After Terraform completes, create a file named `hosts` with the public IP of your instance:

```ini
[webserver]
<EC2_INSTANCE_PUBLIC_IP> ansible_user=ubuntu ansible_ssh_private_key_file=/path/to/your/key.pem
```

Replace `<EC2_INSTANCE_PUBLIC_IP>` with the actual IP and update the path to your SSH private key.

  2.4 Run Ansible Playbook:  

Execute the following command to run the playbook:

```sh
ansible-playbook -i hosts playbook.yml
```

Ansible will connect to the EC2 instance and perform the tasks defined in the playbook.

    Step 3: Managing Workflows with Ansible Tower

Ansible Tower is a web-based UI for managing Ansible. It provides features like access control, job scheduling, and integration with version control systems.

  3.1 Install Ansible Tower:  

Follow the installation guide on the [official Ansible Tower documentation](https://docs.ansible.com/ansible-tower/latest/html/quickinstall/index.html).

  3.2 Configure Ansible Tower:  

- Log in to the Ansible Tower UI.
- Add your credentials (such as AWS keys and SSH keys).
- Create a new Project and link it to your version control system containing your playbooks.
- Create an Inventory in Tower and add your hosts.
- Create a Job Template that points to your playbook.

  3.3 Set Up a Workflow:  

- In Ansible Tower, navigate to the "Templates" section.
- Click on "Add" and select "Add Workflow Template."
- Use the visual workflow editor to define the sequence of jobs.
- Save the workflow.

  3.4 Launch the Workflow:  

- Once the workflow is configured, click on the "Launch" button to start the workflow.
- Monitor the workflow execution within the Tower dashboard.

  3.5 Set Up Notifications:  

- Go to the "Notifications" tab.
- Click on "Add Notification."
- Choose the type, fill in the details, and associate it with your job templates or workflows.

    Conclusion:

This workflow demonstrates how Terraform can be used to provision infrastructure, Ansible to configure and manage the servers, and Ansible Tower to orchestrate workflows and provide a user-friendly interface for automation tasks. Each tool plays a critical role in the DevOps pipeline, and together they create a powerful combination for managing complex environments.





C/ scenario where a CI/CD pipeline is set up using GitHub Actions to trigger the deployment of an AWS EC2 instance using Terraform and then configure it using Ansible.

    Scenario Overview

1. A developer pushes code to the main branch on GitHub.
2. GitHub Actions is configured to trigger a workflow on every push to the main branch.
3. The GitHub Actions workflow has jobs to:
   - Check out the code.
   - Set up Terraform.
   - Provision an EC2 instance using Terraform.
   - Configure the EC2 instance using Ansible.

    Prerequisites

- A GitHub repository with your application code.
- Terraform configuration files for provisioning AWS infrastructure.
- Ansible playbook for configuring the server.
- AWS credentials configured as secrets in the GitHub repository.

    GitHub Actions Workflow

1.   Create GitHub Actions Workflow File:  

Create a file in your repository under `.github/workflows/main.yml` with the following content:

```yaml
name: CI to EC2

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1

      - name: Terraform Init and Apply
        run: |
          terraform init
          terraform apply -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'us-west-2'

      - name: Configure EC2 with Ansible
        run: |
          ansible-playbook -i terraform-inventory ansible/playbook.yml
        env:
          ANSIBLE_HOST_KEY_CHECKING: False
```

This workflow does the following:

- Triggers on a push to the main branch.
- Sets up the latest version of Terraform.
- Initializes Terraform and applies the configuration to provision an EC2 instance.
- Runs an Ansible playbook to configure the provisioned EC2 instance.

2.   Terraform Configuration:  

Create a Terraform configuration file `main.tf` in your repository:

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "GitHub-Action-EC2"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

This Terraform configuration will provision a new EC2 instance.

3.   Ansible Playbook:  

Create an Ansible playbook `playbook.yml` in an `ansible` directory in your repository:

```yaml
- hosts: all
  become: yes
  tasks:
    - name: Update and upgrade apt packages
      apt:
        update_cache: yes
        upgrade: yes

    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Copy website files
      copy:
        src: /path/to/your/website/files
        dest: /var/www/html/
```

This playbook will update the package cache, upgrade packages, install Apache, and copy your website files to the web root.

4.   Ansible Inventory file created by Terraform :  

You'll need a dynamic inventory script or a method to update the Ansible inventory with the IP address of the newly created EC2 instance. One way to do this is to use Terraform's output to create an Ansible  inventory file.

To use Terraform's output to create an Ansible inventory file, you can follow these steps:

    Step 1: Generate Terraform Output

First, you need to ensure that Terraform outputs the necessary information about the provisioned infrastructure. In the `main.tf` file, you have already defined an output for the instance IP:

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

After Terraform applies this configuration, it will output the public IP address of the EC2 instance.

    Step 2: Create a Terraform Output File

You can instruct Terraform to generate an output file in a format that Ansible can understand. For example, you can create a JSON output file with the following command:

```sh
terraform output -json > inventory.json
```

This command will create a `inventory.json` file with the output variables in JSON format.

    Step 3: Parse Terraform Output in GitHub Actions

In your GitHub Actions workflow, after the Terraform apply step, you can add steps to parse the Terraform output and create an Ansible inventory file.

Here's how you can modify the GitHub Actions workflow file to include these steps:

```yaml
      - name: Terraform Output to JSON
        run: |
          terraform output -json > inventory.json
        id: terraform_output

      - name: Create Ansible Inventory
        run: |
          echo "[webserver]" > ansible_inventory
          echo "$(jq -r '.instance_ip.value' inventory.json) ansible_ssh_user=ubuntu ansible_ssh_private_key_file=${{ secrets.SSH_PRIVATE_KEY }}" >> ansible_inventory
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
```

In this example:

- The `terraform output -json` command is used to generate a JSON file with the output data.
- The `jq` tool is used to parse the JSON file and extract the EC2 instance's public IP address.
- An Ansible inventory file named `ansible_inventory` is created with the necessary host information.

    Step 4: Use the Inventory in Ansible Playbook

Finally, you need to tell Ansible to use the generated inventory file when running the playbook. Update the Ansible step in the GitHub Actions workflow:

```yaml
      - name: Configure EC2 with Ansible
        run: |
          ansible-playbook -i ansible_inventory ansible/playbook.yml
        env:
          ANSIBLE_HOST_KEY_CHECKING: False
```

Here, the `-i ansible_inventory` option tells Ansible to use the `ansible_inventory` file you created in the previous step.

    Conclusion

By following these steps, you create a dynamic Ansible inventory file directly from Terraform's output, which allows Ansible to configure the newly provisioned EC2 instance. This process ensures that the infrastructure provisioning and configuration management are tightly integrated and automated within your CI/CD pipeline.


5.   GitHub Secrets:  

Add your AWS credentials as secrets in your GitHub repository settings:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

    Execution Flow

1. A developer pushes changes to the main branch.
2. GitHub Actions detects the push event and starts the `CI to EC2` workflow.
3. The workflow checks out the code, sets up Terraform, and applies the Terraform configuration, which provisions an EC2 instance.
4. Once the instance is provisioned, Terraform outputs the instance IP, which is used by Ansible to configure the server.
5. The workflow runs the Ansible playbook to configure the server with the necessary software and files.

    Conclusion

This scenario provides an automated pipeline using GitHub Actions to deploy and configure an EC2 instance upon code changes to the main branch. The CI/CD pipeline ensures that infrastructure changes are automatically applied and that the server configuration is kept consistent with the codebase.
