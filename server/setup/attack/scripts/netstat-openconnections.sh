#!/bin/sh

# watch 'netstat -tuna | wc -l' 
watch 'netstat -tuna | grep :443 | wc -l; netstat -tuna | grep SYN | wc -l' 
