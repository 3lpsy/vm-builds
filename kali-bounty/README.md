## Kali Bounty

This is a Packer project to build a custom kali vm and create the associated vagrant box. Currently, only qemu/libvirt is supported. In addition, the VM takes up at least 24 GB as that's the most likely required amount of space for my purposes. The system is installed on LVM so theoretically it can be changed later (but I believe you may have to destroy the current vm to do so).

### Similarities to BugMenace

The box is very similar to bugmenace. The idea is that this box the "client" that connects to the bugmenace vpn server. The provision.custom.sh script is nearly identical to bugmenace's provision.install.sh script with the exception that this box's version installs a gnome desktop, spice guest tools, and setups a vagrant user

```
$ packer build -on-error=ask config.json
```

### Weirdness

On last update, Kali really didn't want to upgrade without causing an error due to plymouth/udev. I added some wall hacks to handle it, but if it fails, it gives you the opportunity to ssh into the system, correct the issue (apt-get dist-upgrade), and create a file (in the output) to continue building.

If using this in the distant future (> 1 month), audit provision.update.sh to remove the checks though this may not be necessary.
