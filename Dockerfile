FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
      build-essential libbpf-dev clang llvm linux-tools-common git make linux-libc-dev

# Build libbpf bcc tools
RUN git clone --recursive https://github.com/iovisor/bcc.git && cd bcc/libbpf-tools && \
    make bashreadline bindsnoop biolatency biopattern biosnoop biostacks biotop bitesize \
      cachestat capable cpudist cpufreq drsnoop execsnoop exitsnoop filelife filetop fsdist \
      fsslower funclatency gethostlatency hardirqs klockstat ksnoop llcstat mdflush mountsnoop \
      numamove offcputime oomkill profile readahead runqlat runqlen runqslower sigsnoop \
      slabratetop softirqs solisten statsnoop syncsnoop syscount tcptracer tcpconnect tcpconnlat \
      tcplife tcppktlat tcprtt tcpstates tcpsynbl tcptop vfsstat wakeuptime futexctn memleak opensnoop


FROM ubuntu:22.04 AS executor

# Install debug tools
RUN apt-get update && apt-get install -y \
      procps util-linux numactl strace dstat sysstat nicstat cpuid linux-tools-common bpftrace \
      iproute2 net-tools iputils-ping ncat conntrack tcpdump dnsutils ethtool \
      sudo vim bsdmainutils gdb bash-completion && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy libbpf bcc tools
COPY --from=builder /bcc/libbpf-tools/bashreadline   /usr/sbin/bashreadline
COPY --from=builder /bcc/libbpf-tools/bindsnoop      /usr/sbin/bindsnoop
COPY --from=builder /bcc/libbpf-tools/biolatency     /usr/sbin/biolatency
COPY --from=builder /bcc/libbpf-tools/biopattern     /usr/sbin/biopattern
COPY --from=builder /bcc/libbpf-tools/biosnoop       /usr/sbin/biosnoop
COPY --from=builder /bcc/libbpf-tools/biostacks      /usr/sbin/biostacks
COPY --from=builder /bcc/libbpf-tools/biotop         /usr/sbin/biotop
COPY --from=builder /bcc/libbpf-tools/bitesize       /usr/sbin/bitesize
COPY --from=builder /bcc/libbpf-tools/cachestat      /usr/sbin/cachestat
COPY --from=builder /bcc/libbpf-tools/capable        /usr/sbin/capable
COPY --from=builder /bcc/libbpf-tools/cpudist        /usr/sbin/cpudist
COPY --from=builder /bcc/libbpf-tools/cpufreq        /usr/sbin/cpufreq
COPY --from=builder /bcc/libbpf-tools/drsnoop        /usr/sbin/drsnoop
COPY --from=builder /bcc/libbpf-tools/execsnoop      /usr/sbin/execsnoop
COPY --from=builder /bcc/libbpf-tools/exitsnoop      /usr/sbin/exitsnoop
COPY --from=builder /bcc/libbpf-tools/filelife       /usr/sbin/filelife
COPY --from=builder /bcc/libbpf-tools/filetop        /usr/sbin/filetop
COPY --from=builder /bcc/libbpf-tools/fsdist         /usr/sbin/fsdist
COPY --from=builder /bcc/libbpf-tools/fsslower       /usr/sbin/fsslower
COPY --from=builder /bcc/libbpf-tools/funclatency    /usr/sbin/funclatency
COPY --from=builder /bcc/libbpf-tools/gethostlatency /usr/sbin/gethostlatency
COPY --from=builder /bcc/libbpf-tools/hardirqs       /usr/sbin/hardirqs
COPY --from=builder /bcc/libbpf-tools/klockstat      /usr/sbin/klockstat
COPY --from=builder /bcc/libbpf-tools/ksnoop         /usr/sbin/ksnoop
COPY --from=builder /bcc/libbpf-tools/llcstat        /usr/sbin/llcstat
COPY --from=builder /bcc/libbpf-tools/mdflush        /usr/sbin/mdflush
COPY --from=builder /bcc/libbpf-tools/mountsnoop     /usr/sbin/mountsnoop
COPY --from=builder /bcc/libbpf-tools/numamove       /usr/sbin/numamove
COPY --from=builder /bcc/libbpf-tools/offcputime     /usr/sbin/offcputime
COPY --from=builder /bcc/libbpf-tools/oomkill        /usr/sbin/oomkill
COPY --from=builder /bcc/libbpf-tools/profile        /usr/sbin/profile
COPY --from=builder /bcc/libbpf-tools/readahead      /usr/sbin/readahead
COPY --from=builder /bcc/libbpf-tools/runqlat        /usr/sbin/runqlat
COPY --from=builder /bcc/libbpf-tools/runqlen        /usr/sbin/runqlen
COPY --from=builder /bcc/libbpf-tools/runqslower     /usr/sbin/runqslower
COPY --from=builder /bcc/libbpf-tools/sigsnoop       /usr/sbin/sigsnoop
COPY --from=builder /bcc/libbpf-tools/slabratetop    /usr/sbin/slabratetop
COPY --from=builder /bcc/libbpf-tools/softirqs       /usr/sbin/softirqs
COPY --from=builder /bcc/libbpf-tools/solisten       /usr/sbin/solisten
COPY --from=builder /bcc/libbpf-tools/statsnoop      /usr/sbin/statsnoop
COPY --from=builder /bcc/libbpf-tools/syncsnoop      /usr/sbin/syncsnoop
COPY --from=builder /bcc/libbpf-tools/syscount       /usr/sbin/syscount
COPY --from=builder /bcc/libbpf-tools/tcptracer      /usr/sbin/tcptracer
COPY --from=builder /bcc/libbpf-tools/tcpconnect     /usr/sbin/tcpconnect
COPY --from=builder /bcc/libbpf-tools/tcpconnlat     /usr/sbin/tcpconnlat
COPY --from=builder /bcc/libbpf-tools/tcplife        /usr/sbin/tcplife
COPY --from=builder /bcc/libbpf-tools/tcppktlat      /usr/sbin/tcppktlat
COPY --from=builder /bcc/libbpf-tools/tcprtt         /usr/sbin/tcprtt
COPY --from=builder /bcc/libbpf-tools/tcpstates      /usr/sbin/tcpstates
COPY --from=builder /bcc/libbpf-tools/tcpsynbl       /usr/sbin/tcpsynbl
COPY --from=builder /bcc/libbpf-tools/tcptop         /usr/sbin/tcptop
COPY --from=builder /bcc/libbpf-tools/vfsstat        /usr/sbin/vfsstat
COPY --from=builder /bcc/libbpf-tools/wakeuptime     /usr/sbin/wakeuptime
COPY --from=builder /bcc/libbpf-tools/futexctn       /usr/sbin/futexctn
COPY --from=builder /bcc/libbpf-tools/memleak        /usr/sbin/memleak
COPY --from=builder /bcc/libbpf-tools/opensnoop      /usr/sbin/opensnoop

# Write to /etc/fstab for /sys/kernel/debug, however, maybe required "mount -t debugfs none /sys/kernel/debug"
RUN echo "debugfs /sys/kernel/debug debugfs defaults 0 0" >> /etc/fstab

CMD ["echo", "hello"]
