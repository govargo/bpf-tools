# bpf-tools

Docker image for debug tools using [bcc](https://github.com/iovisor/bcc) and [bpftrace](https://github.com/bpftrace/bpftrace)

## How to use

```bash
$ kubectl debug -it <pod name> --image govargo/bpf-tools --target <target container> -- bash
## enable trace point
mount -t debugfs none /sys/kernel/debug

## for example...
execsnoop
```

## Reference

This repository uses bcc and bpftrace

bcc: https://github.com/iovisor/bcc  
bpftrace: https://github.com/bpftrace/bpftrace
