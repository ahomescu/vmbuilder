#!/bin/bash
#
# requires:
#   bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

declare distro_dir=${abs_dirname}/_distro.$$

## public functions

function setUp() {
  # reinclude hypervisor
  hypervisor=lxc
  . ${abs_dirname}/../../../functions/hypervisor.sh

  mkdir -p ${distro_dir}

  function checkroot() { :; }
  function sync_os() { echo sync_os $*; }
  function mount_proc() { echo mount_proc $*; }
  function mount_dev() { echo mount_dev $*; }
  function mount_sys() { echo mount_sys $*; }
  function create_initial_user() { echo create_initial_user $*; }
  function install_authorized_keys() { echo install_authorized_keys $*; }
  function set_timezone() { echo set_timezone $*; }
  function configure_networking() { echo configure_networking $*; }
  function configure_mounting() { echo configure_mounting $*; }
  function configure_keepcache() { echo configure_keepcache $*; }
  function configure_hypervisor() { echo configure_hypervisor $*; }
  function configure_selinux() { echo configure_selinux $*; }
  function configure_sshd_password_authentication() { echo configure_sshd_password_authentication $*; }
  function configure_sshd_gssapi_authentication() { echo configure_sshd_gssapi_authentication $*; }
  function configure_sshd_permit_root_login() { echo configure_sshd_permit_root_login $*; }
  function configure_sshd_use_dns() { echo configure_sshd_use_dns $*; }
  function configure_sudo_requiretty() { echo configure_sudo_requiretty $*; }
  function install_kernel() { echo install_kernel $*; }
  function install_bootloader() { echo install_bootloader $*; }
  function install_epel() { echo install_epel $*; }
  function install_addedpkgs() { echo install_addedpkgs $*; }
  function clean_packages() { echo clean_packages $*; }
  function run_copy()       { echo run_copy       $*; }
  function xsync_dir()      { echo xsync_dir      $*; }
  function run_execscripts() { echo run_execscripts $*; }
  function run_xexecscripts() { echo run_xexecscripts $*; }
  function install_firstboot() { echo install_firstboot $*; }
  function install_everyboot() { echo install_everyboot $*; }
  function install_firstlogin() { echo install_firstlogin $*; }
  function cleanup_distro() { echo cleanup_distro $*; }
}

function tearDown() {
  rm -rf ${distro_dir}
  rm -rf ${chroot_dir}
}

function test_install_os_diskless() {
  local distro_name=centos
  local diskless=1

  install_os ${chroot_dir} ${distro_dir} >/dev/null
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
