# Docker Commands for Home Lab

This document contains a comprehensive list of common Docker commands categorized for easy reference.

---

## General Commands
- **List running containers**:
  
  docker ps
  
- **List all containers (including stopped)**:
  
  docker ps -a
  
- **Display detailed information about a container**:
  
  docker inspect <container_name_or_id>
  

---

## Starting and Stopping Containers
- **Start a container**:
  
  docker start <container_name_or_id>
  
- **Stop a container**:
  
  docker stop <container_name_or_id>
  
- **Restart a container**:
  
  docker restart <container_name_or_id>
  

---

## Removing Containers
- **Remove a stopped container**:
  
  docker rm <container_name_or_id>
  
- **Remove all stopped containers**:
  
  docker container prune
  

---

## Viewing Logs
- **View logs of a container**:
  
  docker logs <container_name_or_id>
  
- **Tail live logs of a container**:
  
  docker logs -f <container_name_or_id>
  

---

## Executing Commands Inside Containers
- **Execute a command inside a running container**:
  
  docker exec -it <container_name_or_id> <command>
  
- **Open a shell inside a running container**:
  
  docker exec -it <container_name_or_id> /bin/bash
  

---

## Image Management
- **List all images**:
  
  docker images
  
- **Pull an image from Docker Hub**:
  
  docker pull <image_name>
  
- **Remove an image**:
  
  docker rmi <image_name>
  

---

## Networking Commands
- **Expose a container on a specific port**:
  
  docker run -p 8080:80 <image_name>
  
- **List Docker networks**:
  
  docker network ls
  
- **Inspect a Docker network**:
  
  docker network inspect <network_name>
  
- **Create a new network**:
  
  docker network create <network_name>
  
- **Connect a container to a network**:
  
  docker network connect <network_name> <container_name_or_id>
  

---

## Monitoring
- **View resource usage statistics for containers**:
  
  docker stats
  
- **Monitor events happening in Docker**:
  
  docker events
  

---

## Saving and Sharing Images
- **Save a container as an image**:
  
  docker commit <container_name_or_id> <new_image_name>
  
- **Export an image**:
  
  docker save <image_name> > <filename>.tar
  
- **Import an image**:
  
  docker load < <filename>.tar
  
