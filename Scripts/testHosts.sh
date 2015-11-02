#!/bin/bash
# testHosts.sh

echo 'Opening File:' $1
for i in $(< $1)
do
echo -e "\n=== ${i} ==="; \
ssh -oStrictHostKeyChecking=no -i $2 ec2-user@${i} "hostname -f"; \
done
