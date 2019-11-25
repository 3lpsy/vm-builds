On last update, Kali really didn't want to upgrade without causing an error due to plymouth/udev. I added some wall hacks to handle it, but if it fails, it gives you the opportunity to ssh into the system, correct the issue (apt-get dist-upgrade), and create a file (in the output) to continue building.

If using this in the distant future (> 1 month), audit provision.update.sh to remove the checks though this may not be necessary.
