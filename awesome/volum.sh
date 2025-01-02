 #!/bin/bash 



while true; do


    if [[ $(pamixer --get-mute) == "true" ]]; then 
        echo 'MUTE  |  '   
    else
        echo "VOL : $(pamixer --get-volume-human )  |  "
    fi

    sleep 0.01
done
