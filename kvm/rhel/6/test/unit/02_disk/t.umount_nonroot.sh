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
  mkdir -p ${chroot_dir}

  function checkroot() { :; }
  function umount() { :; }
  function after_umount_nonroot() { :; }
}

function tearDown() {
  rm -rf ${chroot_dir}
}

function test_umount_nonroot() {
  umount_nonroot ${chroot_dir}
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
