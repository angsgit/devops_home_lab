# Git Commands Reference

This document contains a comprehensive list of common Git commands categorized for easy reference.

---

## Initialization and Configuration
- **Initialize a new Git repository**:
 
  git init
  
- **Clone an existing repository**:
 
  git clone <repository_url>
  
- **Set global username**:
 
  git config --global user.name "Your Name"
  
- **Set global email**:
 
  git config --global user.email "you@example.com"
  
- **Check configuration settings**:
 
  git config --list
  

---

## Basic Workflow
- **Check repository status**:
 
  git status
  
- **Stage changes**:
 
  git add <file>
  
- **Stage all changes**:
 
  git add .
  
- **Commit staged changes**:
 
  git commit -m "Commit message"
  
- **Push changes to remote repository**:
 
  git push
  
- **Pull changes from remote repository**:
 
  git pull
  

---

## Branching and Merging
- **Create a new branch**:
 
  git branch <branch_name>
  
- **Switch to a branch**:
 
  git checkout <branch_name>
  
- **Create and switch to a new branch**:
 
  git checkout -b <branch_name>
  
- **List all branches**:
 
  git branch
  
- **Merge a branch into the current branch**:
 
  git merge <branch_name>
  
- **Delete a branch**:
 
  git branch -d <branch_name>
  

---

## Stashing
- **Stash changes**:
 
  git stash
  
- **Apply the most recent stash**:
 
  git stash apply
  
- **List all stashes**:
 
  git stash list
  
- **Drop a stash**:
 
  git stash drop
  

---

## Viewing History
- **View commit history**:
 
  git log
  
- **View commit history as a graph**:
 
  git log --graph
  
- **View a single line for each commit**:
 
  git log --oneline
  

---

## Undoing Changes
- **Unstage a file**:
 
  git reset <file>
  
- **Revert a commit**:
 
  git revert <commit_hash>
  
- **Discard changes in a file**:
 
  git checkout -- <file>
  

---

## Remote Repositories
- **Add a remote repository**:
 
  git remote add <name> <url>
  
- **View remote repositories**:
 
  git remote -v
  
- **Remove a remote repository**:
 
  git remote remove <name>
  

---

## Advanced Commands
- **Squash commits interactively**:
 
  git rebase -i HEAD~<number_of_commits>
  
- **Cherry-pick a commit**:
 
  git cherry-pick <commit_hash>
  
- **Show changes between commits**:
 
  git diff <commit1_hash> <commit2_hash>
  
