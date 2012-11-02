#!/bin/bash
#
# description:
#  Controll a kvm process
#
# requires:
#  bash
#  dirname, pwd
#  sed, head
#  /usr/libexec/qemu-kvm, date, seq, cat, ifconfig, brctl
#
# usage:
#
#  $0 start --image-path=/path/to/vmimage.raw
#
set -e

## private functions

function register_options() {
  debug=${debug:-}
  [[ -z "${debug}" ]] || set -x

  name=${name:-rhel6}

  image_format=${image_format:-raw}
  image_file=${image_file:-${name}-${image_format}}
  image_path=${image_path:-${image_file}}

  brname=${brname:-br0}

  kvm_path=${kvm_path:-/usr/libexec/qemu-kvm}
  kvm_opts=${kvm_opts:-}

  mem_size=${mem_size:-1024}
  cpu_num=${cpu_num:-1}

  vnc_addr=${vnc_addr:-0.0.0.0}
  vnc_port=${vnc_port:-1001}

  monitor_addr=${monitor_addr:-127.0.0.1}
  monitor_port=${monitor_port:-4444}

  vif_name=${vif_name:-${name}-${monitor_port}}
  vif_num=${vif_num:-1}

  vendor_id=${vendor_id:-52:54:00}
}

function gen_macaddr() {
  local offset=${1:-0}
  printf "%s:%s" ${vendor_id} $(date --date "${offset} hour ago" +%H:%M:%S)
}

function shlog() {
  echo "\$ $*"
  eval $*
}

function run_kvm() {
  case "$1" in
  start)
    shlog ${kvm_path} ${kvm_opts} \
     -name    ${name} \
     -m       ${mem_size} \
     -smp     ${cpu_num} \
     -vnc     ${vnc_addr}:${vnc_port} \
     -drive   file=${image_path},media=disk,boot=on,index=0,cache=none \
     -monitor telnet:${monitor_addr}:${monitor_port},server,nowait \
     $(for i in $(seq 1 ${vif_num}); do offset=$((${i} - 1)); [[ "${offset}" == 0 ]] && suffix= || suffix=.${offset}; echo \
     -net     nic,macaddr=$(gen_macaddr ${offset}),model=virtio \
     -net     tap,ifname=${vif_name}${suffix},script=,downscript= \
     ; done) \
     -daemonize

    # basically this scripts add only 1 vif to the bridge interface,
    # even if creating more than 2 vifs with vif-num.
    shlog ifconfig ${vif_name} up
    shlog brctl addif ${brname} ${vif_name}
    ;;
  dump)
    cat <<-EOS
	name=${name}
	image_format=${image_format}
	image_file=${image_file}
	image_path=${image_path}

	brname=${brname}

	kvm_path=${kvm_path}
	kvm_opts=${kvm_opts}

	mem_size=${mem_size}
	cpu_num=${cpu_num}

	vnc_addr=${vnc_addr}
	vnc_port=${vnc_port}

	monitor_addr=${monitor_addr}
	monitor_port=${monitor_port}
	EOS
    ;;
  *)
    echo $"USAGE: $0 [start] OPTIONS..." >&2
    return 2
  ;;
  esac
}

### read-only variables

readonly abs_dirname=$(cd $(dirname $0) && pwd)

### include files

. ${abs_dirname}/../functions/utils.sh

### prepare

extract_args $*

### main

cmd="$(echo ${CMD_ARGS} | sed "s, ,\n,g" | head -1)"

register_options
run_kvm ${cmd}