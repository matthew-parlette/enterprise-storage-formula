enterprise-storage-formula
==========================

Create and mount the glusterfs volume for the enterprise system.

This assumes that the following has been completed:

* disk has been partitioned (one partition)

    sudo fdisk /dev/sdb

* filesystem has been created

    $ sudo apt-get install xfsprogs xfsdump

    $ sudo mkfs.xfs /dev/sdb1

current status
==============
* start glusterfs volume on a single server

todo
====
* support multiple peers
