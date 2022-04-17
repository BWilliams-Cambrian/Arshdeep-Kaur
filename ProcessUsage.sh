#!/bin/bash
numberofprocesses=0
file="ProcessUsageReport - "$(date +'%m_%d_%Y')""
touch "$HOME/$file" || exit
echo "Top 5 processes running on system by CPU usage"
echo ""
function log file() {
    echo "$2 from group $8 started process $9 on $3 $4 $5 $6 $7" >> "$HOME/$file"
}
function killprocess() {
    if [ $1 == "root" ]; then
        echo "process Cannot be delete started by root."
    else
        kill -SIGKILL $2
        echo "process $3 started by user $1 killed [$(date)]" >> "$HOME/$file"
        ((numberofprocesses++))
    fi
}
while IFS=" " read -r pid user week month day Time year group cmd cpu
do
    echo "$cmd"
    log file $pid $user $week $month $day $Time $year $group $cmd
done < <(ps -eo pid,user,lstart,group,cmd,%cpu --sort=-%cpu | tail -n +2 | head -5)

read -r -p "Do you want to delete all 5 processes? [Y/n]" input
case $input in
    [yY][eE][sS]|[yY])
        while IFS=" " read -r pid user week month day Time year group cmd cpu
        do
            log file $pid $user $week $month $day $Time $year $group $cmd
            killprocess $user $pid $cmd  
        done < <(ps -eo pid,user,lstart,group,cmd,%cpu --sort=-%cpu | tail -n +2 | head -5)
        ;;
    [nN][oO]|[nN])
        echo "you said no"
        ;;
    *)
        echo "Invalid input..."
        exit 1
        ;;
esac
echo "$numberofprocesses number of processes are killed."
