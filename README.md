# bpf-tools

Docker image for debug tools using [bcc](https://github.com/iovisor/bcc) and [bpftrace](https://github.com/bpftrace/bpftrace)

## How to use

```bash
## Note: --profile=sysadmin can be used from K8s v1.30
$ kubectl debug -it <pod name> --image govargo/bpf-tools --profile sysadmin --target <target container> -- bash
## enable trace point
mount -t debugfs none /sys/kernel/debug

## for example...
execsnoop
```

## Reference

This repository uses bcc and bpftrace, other tool

bcc: https://github.com/iovisor/bcc  
bpftrace: https://github.com/bpftrace/bpftrace  
bpf-perf-tools-book: https://github.com/brendangregg/bpf-perf-tools-book
