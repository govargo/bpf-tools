# bpf-tools

Docker image for debug tools using [bcc](https://github.com/iovisor/bcc) and [bpftrace](https://github.com/bpftrace/bpftrace)

## How to build

Note: This docker image was tested only to GKE nodes(Ubuntu only) and containers

```
# Change KERNEL_VERSION, if needed
docker build -t <repository>/bpf-tools:<tag> --build-arg KERNEL_VERSION=5.15.0-1054-gke .
```

## How to use

```bash
## Note: --profile=sysadmin can be used from kubectl v1.30
$ kubectl debug -it <pod name> --image govargo/bpf-tools --profile sysadmin --target <target container> -- bash

## for example...
execsnoop
```

## Reference

This repository uses bcc and bpftrace, other tool

bcc: https://github.com/iovisor/bcc  
bpftrace: https://github.com/bpftrace/bpftrace  
bpf-perf-tools-book: https://github.com/brendangregg/bpf-perf-tools-book
