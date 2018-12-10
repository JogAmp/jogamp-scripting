#!/bin/bash
kill -9 `ps -ef | grep jenkins.war | grep -v grep | awk '{ print $2 }'`

