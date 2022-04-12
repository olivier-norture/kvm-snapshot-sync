# kvm-snapshot-sync

# VMs

## Host

The host must be able to provide driver for VMs and that's all.
All userspace must be move to a dedicated VMs.

This means I need to have 3 VMs:
* One for standard usage on Linux
* One for gamming on Windows
* One for work on Linux

## Overall idea
The main idea is to be able to easily copy/paste a VM from a Desktop to a Laptop.

The transfert must be quick ideally less than 5min using a Gigabyte network.

I want to use a NAS as intermediare storage layout; this means the desktop and the laptop have to:
1. On stop: send the new state to the NAS
2. Before startup: check if there is a new version available on the NAS
        a. if yes: download the new version and start it
        b. if not: just start
3. In case of conflit: could append if any users forgot to send the new version to the server; block everything and let the user decide which version use
        a. if user select the one from the server then erase the current one and download the
one from the server
        b. if user select the current one then remove the new one from server and download the current one

### Snapshot startegy
In order to not send/receive hundred of gigabyte through the server each time we want to start / stop a VM we can rely on the snapshot
strategy of KVM.

This means before starting a VM we have to create a new snapshot and after shutdown try to send this snapshot to the external server and
block the vm start until we were able to send the new snapshot to the server.

We may need an option to shutdown the VM without havig to send the state to the server.

#### One day of work
A regulat one day of work is less than 12GB for a snapshot with / and /home in 2 different files

Stangely the biggest one the the /home one for 12GB whereas the / in only few hundred of MB (400).

```
-rwxrwxrwx  1 libvirt-qemu libvirt-qemu  12G Apr 12 19:45 ultra-home-snap-desktop-2022-04-11.qcow2
-rwxrwxrwx  1 libvirt-qemu libvirt-qemu 404M Apr 12 19:45 ultra-system-snap-desktop-2022-04-11.qcow2
```

#### Compact

From snapshots there is an option to compact it back to a previous one (until we reach the original image).
It's a great feature because this means we can reduce the number of snapshot to transfert and
even decide that
from a point it's maybe better to do a full synchronization instead of copying a hunderd of snapshot.

### Takeover from desktop to laptop
Sometime I may want beeing able to let the VM runs from the desktop and do a distant connection from the laptop.
This way I could reduce the battery consuption from the laptop and easilly takeover from the desktop to the laptop and then
came back to the desktop without any downtime.


## Commands list

```
# Create a new snapshot
# Merge an existing snapshot
# Delete an existing snapshot

# Send a snapshot to the server
# Get a snapshot from the server

# List remote snapshots
# List local snapshots
# Compute delta

# Start a VM
# Do a snapshot and start a VM
# Stop a VM
# Stop a VM and send snapthot to the server
```

## Copy file to server

There is many option, the easiest one `scp` is maybe not the more powerfull but I will start with this one to validate the workflow and then take a look to alternative like rsync.

### Borg
This tool looks great! But it's consume CPU and add time to compute delta before send it through the network.
I think it doesn't fit what i'm looking for.

## Sources
[libvirt and bord](https://github.com/milkey-mouse/backup-vm)
[kvm-borg-backup](https://github.com/Nozzie/kvm-borg-backup)
[Borg](https://borgbackup.readthedocs.io/en/stable/index.html)
