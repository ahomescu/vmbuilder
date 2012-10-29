#!/bin/bash
#
# requires:
#   bash
#

## include files

. ./helper_shunit2.sh

## variables

## public functions

function test_load_plugin_distro_centos6() {
  load_plugin_distro centos6
  assertEquals $? 0
}

function test_load_plugin_distro_sl6() {
  load_plugin_distro centos6
  assertEquals $? 0
}

function test_load_plugin_distro_unknown() {
  load_plugin_distro unknown
  assertNotEquals $? 0
}


## shunit2

. ${shunit2_file}
