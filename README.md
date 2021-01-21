# wsl-cloud-init

Starting [cloud-init](https://cloudinit.readthedocs.io/en/latest/) within a [WSL2](https://docs.microsoft.com/en-us/windows/wsl/) container.

## Installation

Checkout this repository to `c:/opt/wsl/cloud-init/`

## Configuration
### WSL Kernel

Windows: `~/.wslconfig`

```
[wsl2]
kernelCommandLine="ds=nocloud;seedfrom=/mnt/c/opt/wsl/cloud-init/" # NOTE: keep trailing slash of seedfrom
```

### cloud-init Config Files

Mandatory
- `c:/opt/wsl/cloud-init/meta-data`
- `c:/opt/wsl/cloud-init/user-data`

Optional
- `c:/opt/wsl/cloud-init/vendor-data`


## Invocation
```
wsl.exe [-d DistroName] -u root -e /mnt/c/opt/wsl/cloud-init/wsl-cloud-init.sh [ --noclean | <seed_directory> ]
```
