#!/bin/bash

yum -y update
amazon-linux-extras install -y nginx1
systemctl start nginx