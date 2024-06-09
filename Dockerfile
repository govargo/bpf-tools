FROM ubuntu:22.04 AS bcc-builder

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

RUN git clone https://github.com/brendangregg/bpf-perf-tools-book.git


FROM ubuntu:22.04 AS bpftrace-builder

RUN apt-get update && apt-get install -y curl xz-utils
RUN curl -LO https://github.com/bpftrace/bpftrace/releases/download/v0.20.4/binary_tools_man-bundle.tar.xz && \
    xz -dv binary_tools_man-bundle.tar.xz && tar xfv binary_tools_man-bundle.tar


FROM ubuntu:22.04 AS executor

ARG KERNEL_VERSION=5.15.0-1054-gke

# Install debug tools
RUN apt-get update && apt-get install -y linux-headers-${KERNEL_VERSION} linux-libc-dev libc6-dev \
      procps util-linux numactl strace dstat sysstat nicstat cpuid linux-tools-common \
      iproute2 net-tools iputils-ping ncat conntrack tcpdump dnsutils ethtool \
      sudo vim bsdmainutils gdb bash-completion && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create symbolic link for bpftrace
RUN ln -sf /usr/src/linux /lib/modules/${KERNEL_VERSION}/source && ln -sf /usr/src/linux /lib/modules/${KERNEL_VERSION}/build

# Copy libbpf bcc tools
COPY --from=bcc-builder /bcc/libbpf-tools/bashreadline   /usr/sbin/bashreadline
COPY --from=bcc-builder /bcc/libbpf-tools/bindsnoop      /usr/sbin/bindsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/biolatency     /usr/sbin/biolatency
COPY --from=bcc-builder /bcc/libbpf-tools/biopattern     /usr/sbin/biopattern
COPY --from=bcc-builder /bcc/libbpf-tools/biosnoop       /usr/sbin/biosnoop
COPY --from=bcc-builder /bcc/libbpf-tools/biostacks      /usr/sbin/biostacks
COPY --from=bcc-builder /bcc/libbpf-tools/biotop         /usr/sbin/biotop
COPY --from=bcc-builder /bcc/libbpf-tools/bitesize       /usr/sbin/bitesize
COPY --from=bcc-builder /bcc/libbpf-tools/cachestat      /usr/sbin/cachestat
COPY --from=bcc-builder /bcc/libbpf-tools/capable        /usr/sbin/capable
COPY --from=bcc-builder /bcc/libbpf-tools/cpudist        /usr/sbin/cpudist
COPY --from=bcc-builder /bcc/libbpf-tools/cpufreq        /usr/sbin/cpufreq
COPY --from=bcc-builder /bcc/libbpf-tools/drsnoop        /usr/sbin/drsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/execsnoop      /usr/sbin/execsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/exitsnoop      /usr/sbin/exitsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/filelife       /usr/sbin/filelife
COPY --from=bcc-builder /bcc/libbpf-tools/filetop        /usr/sbin/filetop
COPY --from=bcc-builder /bcc/libbpf-tools/fsdist         /usr/sbin/fsdist
COPY --from=bcc-builder /bcc/libbpf-tools/fsslower       /usr/sbin/fsslower
COPY --from=bcc-builder /bcc/libbpf-tools/funclatency    /usr/sbin/funclatency
COPY --from=bcc-builder /bcc/libbpf-tools/gethostlatency /usr/sbin/gethostlatency
COPY --from=bcc-builder /bcc/libbpf-tools/hardirqs       /usr/sbin/hardirqs
COPY --from=bcc-builder /bcc/libbpf-tools/klockstat      /usr/sbin/klockstat
COPY --from=bcc-builder /bcc/libbpf-tools/ksnoop         /usr/sbin/ksnoop
COPY --from=bcc-builder /bcc/libbpf-tools/llcstat        /usr/sbin/llcstat
COPY --from=bcc-builder /bcc/libbpf-tools/mdflush        /usr/sbin/mdflush
COPY --from=bcc-builder /bcc/libbpf-tools/mountsnoop     /usr/sbin/mountsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/numamove       /usr/sbin/numamove
COPY --from=bcc-builder /bcc/libbpf-tools/offcputime     /usr/sbin/offcputime
COPY --from=bcc-builder /bcc/libbpf-tools/oomkill        /usr/sbin/oomkill
COPY --from=bcc-builder /bcc/libbpf-tools/profile        /usr/sbin/profile
COPY --from=bcc-builder /bcc/libbpf-tools/readahead      /usr/sbin/readahead
COPY --from=bcc-builder /bcc/libbpf-tools/runqlat        /usr/sbin/runqlat
COPY --from=bcc-builder /bcc/libbpf-tools/runqlen        /usr/sbin/runqlen
COPY --from=bcc-builder /bcc/libbpf-tools/runqslower     /usr/sbin/runqslower
COPY --from=bcc-builder /bcc/libbpf-tools/sigsnoop       /usr/sbin/sigsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/slabratetop    /usr/sbin/slabratetop
COPY --from=bcc-builder /bcc/libbpf-tools/softirqs       /usr/sbin/softirqs
COPY --from=bcc-builder /bcc/libbpf-tools/solisten       /usr/sbin/solisten
COPY --from=bcc-builder /bcc/libbpf-tools/statsnoop      /usr/sbin/statsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/syncsnoop      /usr/sbin/syncsnoop
COPY --from=bcc-builder /bcc/libbpf-tools/syscount       /usr/sbin/syscount
COPY --from=bcc-builder /bcc/libbpf-tools/tcptracer      /usr/sbin/tcptracer
COPY --from=bcc-builder /bcc/libbpf-tools/tcpconnect     /usr/sbin/tcpconnect
COPY --from=bcc-builder /bcc/libbpf-tools/tcpconnlat     /usr/sbin/tcpconnlat
COPY --from=bcc-builder /bcc/libbpf-tools/tcplife        /usr/sbin/tcplife
COPY --from=bcc-builder /bcc/libbpf-tools/tcppktlat      /usr/sbin/tcppktlat
COPY --from=bcc-builder /bcc/libbpf-tools/tcprtt         /usr/sbin/tcprtt
COPY --from=bcc-builder /bcc/libbpf-tools/tcpstates      /usr/sbin/tcpstates
COPY --from=bcc-builder /bcc/libbpf-tools/tcpsynbl       /usr/sbin/tcpsynbl
COPY --from=bcc-builder /bcc/libbpf-tools/tcptop         /usr/sbin/tcptop
COPY --from=bcc-builder /bcc/libbpf-tools/vfsstat        /usr/sbin/vfsstat
COPY --from=bcc-builder /bcc/libbpf-tools/wakeuptime     /usr/sbin/wakeuptime
COPY --from=bcc-builder /bcc/libbpf-tools/futexctn       /usr/sbin/futexctn
COPY --from=bcc-builder /bcc/libbpf-tools/memleak        /usr/sbin/memleak
COPY --from=bcc-builder /bcc/libbpf-tools/opensnoop      /usr/sbin/opensnoop

# udplife uses /usr/local/bin/bpftrace, so create symbolic link
COPY --from=bcc-builder /bpf-perf-tools-book/exercises/Ch10_Networking/udplife.bt /usr/sbin/udplife.bt
RUN ln -s /usr/sbin/bpftrace /usr/local/bin/bpftrace

COPY --from=bpftrace-builder /bin/* /usr/sbin/

# Write to /etc/fstab for /sys/kernel/debug, however, maybe required "mount -t debugfs none /sys/kernel/debug"
RUN echo "debugfs /sys/kernel/debug debugfs defaults 0 0" >> /etc/fstab

CMD ["echo", "hello"]
