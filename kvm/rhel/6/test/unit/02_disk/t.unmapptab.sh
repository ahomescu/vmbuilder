#!/bin/bash
#
# requires:
#   bash
#

## include files

. ./helper_shunit2.sh

## variables

## public functions

function setUp() {
  mkdisk ${disk_filename} ${totalsize} 2>/dev/null
  mkptab ${disk_filename}
  mapptab ${disk_filename}
}

function tearDown() {
  rm -f ${disk_filename}
}

function test_unmapptab() {
  unmapptab ${disk_filename}
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}