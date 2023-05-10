# JG1DevOps

## Mihails homework

1. Wiki link: https://...
2. Mine branch with code for task 2 and task 3 <branche_name>

# Romans homework
---
# Task 1

- The first I tested my all instances with Ansible ping command from my master instance - result was successful!
- Before to run a playbook "AdditionalPackages.yml" I edited a line 4 and add my
hosts (my db servers - I made additional group in Ansible hosts file: "DB")

- Run a command "ansible-playbook -u ubuntu AdditionalPackages.yml".

Result wasn't successful!

As I understood from error message, problems was with permissions!
I run a command as sudo user again.

Result wasn't successful - now error with ssh key!

#### Error msg:
###### fatal: [db1]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Warning: Permanently added '54.82.121.224' (ED25519) to the list of known hosts. \r\nubuntu@54.82.121.224: Permission denied (publickey).", "unreachable": true}

###### fatal: [db2]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Host key verification failed.", "unreachable": true}

- I tried to add my AWS ssh key manualy to my db1 server directory ".ssh" and afterwards run playbook "AdditionalPackages.yml" again.

Result wasn't successful!

The same error!

---