if ping -c 1 $SECONDARY &> /dev/null

then

    echo "Secondary node is up."

else

    echo "Secondary node is down."

fi