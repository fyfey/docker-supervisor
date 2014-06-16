#!/bin/bash

echo "Here is your private key, you can use it to SSH in. Keep it safe!\n\n"
cat /root/.ssh/id_rsa

echo "\nStarting supervisord..."
/usr/bin/supervisord

