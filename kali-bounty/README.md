Packer and Arch were causing me problems so I created a buildervm (ubuntu) and created the box there.

For this reason, i removed:

```
      "accelerator": "kvm",
         "qemuargs": [
        ["-m", "8192m"],
        ["--cpu", "host"],
        ["--no-acpi"],
        ["-vga", "qxl"],
        ["-smp", "8"]
      ]
```

It's possible the issue is with the kali net iso.
