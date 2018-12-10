#!/bin/bash
kill -9 `ps -ef | grep jabot.jar | grep -v grep | awk '{ print $2 }'`

