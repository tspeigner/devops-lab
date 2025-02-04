# Define the path to Ansible files
ANSIBLE_DIR=~/repos/devops-lab-environment/ansible/

# Run Terraform
terraform apply -auto-approve

# Extract the public IP from Terraform and update Ansible inventory
INSTANCE_IP=$(terraform output -raw instance_public_ip)

# Generate the inventory file dynamically
echo "[app_servers]" > $ANSIBLE_DIR/inventory.ini
echo "app01 ansible_host=$INSTANCE_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tommy" >> $ANSIBLE_DIR/inventory.ini

# Wait for SSH to become available
echo "Waiting for SSH to be ready on $INSTANCE_IP..."
until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i ~/.ssh/tommy ubuntu@$INSTANCE_IP "echo SSH is ready" &> /dev/null
do
  echo "SSH not ready yet. Retrying in 5 seconds..."
  sleep 5
done

echo "SSH is ready! Running Ansible..."

# Run the Ansible playbook
ansible-playbook -i $ANSIBLE_DIR/inventory.ini $ANSIBLE_DIR/deploy.yml
