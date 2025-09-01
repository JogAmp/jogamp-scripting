#!/bin/sh

# netstat -ntu | tail -n +3 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
netstat -ntu | awk -F"[ :]+" 'NR>2{print $6}'|sort|uniq -c|sort -nr
