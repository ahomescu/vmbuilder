#!/bin/bash
#
# requires:
#  bash
#  cd
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## public functions

function setUp() {
  mkdir -p ${chroot_dir}/dev

  function checkroot() { :; }
  function mount() { :; }
}

function tearDown() {
  rm -rf ${chroot_dir}
}

function test_before_mount_dev() {
  before_mount_dev ${chroot_dir} >/dev/null
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}