# Jenkins Commands Reference

This document contains a comprehensive list of common Jenkins commands categorized for easy reference.

---

## Jenkins CLI Commands

### **Basic Commands**
- **List all jobs**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> list-jobs
  
- **Get job information**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> get-job <job_name>
  
- **Create a new job**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> create-job <job_name> < config.xml
  
- **Delete a job**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> delete-job <job_name>
  
- **Disable a job**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> disable-job <job_name>
  
- **Enable a job**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> enable-job <job_name>
  

### **Build Commands**
- **Trigger a build**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> build <job_name>
  
- **Trigger a build with parameters**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> build <job_name> -p <parameter1>=<value1> -p <parameter2>=<value2>
  
- **Cancel a build**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> cancel-build <job_name> <build_number>
  
- **View build logs**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> console <job_name> <build_number>
  

---

## Jenkins Groovy Commands (Script Console)

### **Job Management**
- **List all jobs**:
  groovy
  Jenkins.instance.items.each { job -> println(job.fullName) }
  
- **Disable a job**:
  groovy
  Jenkins.instance.getItemByFullName("<job_name>").disable()
  
- **Enable a job**:
  groovy
  Jenkins.instance.getItemByFullName("<job_name>").enable()
  
- **Delete a job**:
  groovy
  Jenkins.instance.getItemByFullName("<job_name>").delete()
  

### **Build Management**
- **Trigger a build**:
  groovy
  Jenkins.instance.getItemByFullName("<job_name>").scheduleBuild2(0)
  
- **Abort a build**:
  groovy
  Jenkins.instance.getItemByFullName("<job_name>").builds.findAll { it.isBuilding() }.each { it.doStop() }
  

---

## User and Plugin Management

### **User Management**
- **Create a new user (Groovy)**:
  groovy
  def hudsonRealm = Jenkins.instance.getSecurityRealm()
  hudsonRealm.createAccount("<username>", "<password>")
  Jenkins.instance.save()
  
- **List all users (Groovy)**:
  groovy
  Jenkins.instance.getSecurityRealm().getAllUsers().each { user -> println(user.getId()) }
  

### **Plugin Management**
- **List all plugins**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> list-plugins
  
- **Install a plugin**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> install-plugin <plugin_name>
  
- **Uninstall a plugin**:
  groovy
  Jenkins.instance.pluginManager.plugins.find { it.getShortName() == "<plugin_name>" }.doUninstall()
  
- **Update all plugins**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> safe-restart
  

---

## Jenkins System Management

### **System Operations**
- **Restart Jenkins**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> safe-restart
  
- **Shutdown Jenkins**:
 
  java -jar jenkins-cli.jar -s <JENKINS_URL> safe-shutdown
  

### **Backup Configurations (Groovy)**
- **Backup jobs**:
  groovy
  Jenkins.instance.items.each { job ->
      println(job.fullName)
      job.save()
  }
  

---

