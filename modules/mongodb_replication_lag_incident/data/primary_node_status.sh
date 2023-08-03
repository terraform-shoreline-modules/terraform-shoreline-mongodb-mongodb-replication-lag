if ping -c 1 $PRIMARY &> /dev/null

then

    echo "Primary node is up."

else

    echo "Primary node is down."

fi