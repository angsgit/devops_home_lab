# To deploy VM's through Ansible some prerequisites must be completed:

 - This is assuming you already have a esxHost and a ansible container setup

 - VMware vSphere Credentials: Ensure you have:

    - ESXi/vCenter hostname or IP.
    - Username and password with necessary permissions.

- Ansible VMware Collection: The community.vmware Ansible collection must be installed.

    - If not already installed, inside your Ansible container:
        ansible-galaxy collection install community.vmware --upgrade

    ---

# Template VM: Prepare a template VM or ISO on your ESXi/vCenter that can be used to deploy the new VM.

## Step 1: Install the OS
1. **Upload the Installation ISO**:
   - Upload the desired OS ISO to your ESXi datastore via the vSphere/ESXi web interface.

2. **Create a New VM**:
   - Go to your ESXi or vCenter interface.
   - Create a new VM, specifying the OS type and version.
   - Attach the ISO as a CD/DVD drive in the VM settings.
   - Boot the VM and install the OS.

---

## Step 2: Configure the OS
After the OS is installed, perform these essential configurations:

### **Linux VM Configuration**:
1. **Update the System**:
   ```
   sudo apt update && sudo apt upgrade -y
   ```

2. **Install VMware Tools** (for better ESXi integration):
   ```
   sudo apt install open-vm-tools -y
   ```

3. **Set a Default User**:
   - Create a user (e.g., `admin`) with sudo privileges:
     ```
     sudo adduser admin
     sudo usermod -aG sudo admin
     ```

4. **Install Cloud-Init (Optional)**:
   Cloud-Init automates first-boot configurations like SSH keys and hostname setup:
   ```
   sudo apt install cloud-init -y
   ```

5. **Clean Up Temporary Files**:
   ```
   sudo apt clean
   sudo rm -rf /var/log/*
   sudo rm -rf /tmp/*
   ```

6. **Remove SSH Host Keys** (to avoid duplicates in new VMs):
   ```
   sudo rm -f /etc/ssh/ssh_host_*
   ```

7. **Reset Machine ID**:
   ```
   sudo truncate -s 0 /etc/machine-id
   ```

---

## Step 3: Convert to a Template
1. Power off the VM.
2. In vCenter/ESXi, right-click the VM and choose **Convert to Template**.

---

## Step 4: Use the Template with Ansible
Once the template is ready:
- Use Ansible to deploy new VMs from this template by specifying it in the playbook:
  ```yaml
  template: "YourTemplateName"
  ```

---

## Summary
You have now created a VM template that can be reused to quickly deploy new virtual machines with pre-configured settings.
