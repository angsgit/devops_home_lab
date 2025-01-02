# Steps to Set Up and Test Ansible in a Docker Container

## Step 1: Create a Dockerfile
1. Create a directory for the Dockerfile:
   
   mkdir ansible-docker && cd ansible-docker
   
2. Create a file named `Dockerfile`:
   
   vim Dockerfile
   
3. Add the following content to the `Dockerfile`:

   dockerfile
   FROM ubuntu:20.04

   # Set up locales to avoid encoding issues
   RUN apt-get update && apt-get install -y locales && \
       locale-gen en_US.UTF-8
   ENV LANG=en_US.UTF-8 \
       LANGUAGE=en_US:en \
       LC_ALL=en_US.UTF-8

   # Set environment variables to avoid interactive prompts
   ENV DEBIAN_FRONTEND=noninteractive

   # Install dependencies
   RUN apt update && apt install -y \
       python3 python3-pip sshpass \
       && pip3 install ansible pyvmomi \
       && apt clean && rm -rf /var/lib/apt/lists/*

   # Set working directory
   WORKDIR /ansible

   # Set entrypoint to Ansible
   ENTRYPOINT ["ansible-playbook"]
   
4. Save and exit the file.

---

## Step 2: Build the Docker Image
Build the image from the Dockerfile:

docker build -t ansible-image .


---

## Step 3: Run the Docker Container
Run the container interactively:

docker run -it --entrypoint /bin/bash ansible-image


---

## Step 4: Create an Inventory File
1. Inside the container, navigate to the `/ansible` directory:
   
   cd /ansible
   
2. Create the `inventory.yml` file:
   
   vim inventory.yml
   
3. Add the following content:
   yaml
   all:
     hosts:
       localhost:
         ansible_connection: local
   
4. Save and exit (`Esc`, then `:wq`).

---

## Step 5: Create a Test Playbook
1. In the same `/ansible` directory, create the `test-playbook.yml` file:
   
   vim test-playbook.yml
   
2. Add the following content:
   yaml
   ---
   - name: Test Playbook
     hosts: localhost
     tasks:
       - name: Print a debug message
         debug:
           msg: "Ansible is working correctly inside the container!"
   
3. Save and exit (`Esc`, then `:wq`).

---

## Step 6: Run the Playbook
Run the playbook using the inventory file:

ansible-playbook -i inventory.yml test-playbook.yml


---

## Step 7: Verify the Output
You should see output similar to this:

PLAY [Test Playbook] ******************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************
ok: [localhost]

TASK [Print a debug message] **********************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ansible is working correctly inside the container!"
}

PLAY RECAP ****************************************************************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


---

## Summary
You successfully:
1. Built a custom Docker image for Ansible.
2. Ran an Ansible playbook in a container.
3. Verified that Ansible works correctly.
