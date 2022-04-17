#!/bin/bash
Totalusrscreated=0
Totalgrpscreated=0
function usrname () {
    First=`echo $1`
    Last=`echo $2`
    Department=`echo $3`
    Firstcharacter=`echo "${First:0:1}"`
    Firstcharacter=`echo "${Firstcharacter,,}"`
    Lastcharacter=`echo "${Last:0:7}"`
    Lastcharacter=`echo "${Lastcharacter,,}"`
    Department=`echo "${Department,,}"`
    Department=`echo "${Department//$'\r'/}"`
    usrname=`echo "$Firstcharacter$Lastcharacter"`
}
while IFS="," read -r First Last Department 
do 
    usrname $First $Last $Department
    usr_output=`echo "$(awk -F: '{ print $1}' /etc/passwd | grep $usrname)"`
    if [ -z "$user_output" ];  then
        echo "username doesnot exist = $usrname"
        echo "creating user $usrname"
        sudo adduser $usrname --disabled-password --gecos ""
        ((Totalusrscreated++))
    else 
        echo "This user $usrname already exist"
    fi
    echo "Creating group for department"
    grp_output=`echo "$(sudo awk -F: '{ print $1}' /etc/group | grep ^$Department)"`
    if [ -z "$grp_output" ]; then
        echo "Group doesn't exist = $Department"
        echo "creating group $Department"
        sudo /usr/sbin/groupadd $Department
        ((Totalgrpscreated++))
    else
        echo "This group $Department already exist"
    fi
    echo "Assigning Group $Department to User $usrname"
    echo "$(sudo usermod -g $Department $usrname)"
done < <(tail -n +2 EmployeeNames.csv)
echo "$Totalusrscreated is number of users created"
echo "$Totalgrpscreated is number of groups created"


