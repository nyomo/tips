#!/bin/zsh

TARGETUSER="hogehoge"
PASSWORD="hogepass"

GID=`sudo dscl . list groups gid|grep \^staff | tail  -1  | awk '{print $2}'`

sudo dscl . -create /Users/$TARGETUSER
sudo dscl . -create /Users/$TARGETUSER UserShell /bin/bash
sudo dscl . -create /Users/$TARGETUSER RealName $TARGETUSER
sudo dscl . -create /Users/$TARGETUSER Picture "/Library/User Pictures/Fun/Gingerbread Man.tif"

maxid=$(sudo dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
newid=$((maxid+1))

sudo dscl . -create /Users/$TARGETUSER UniqueID         $newid
sudo dscl . -create /Users/$TARGETUSER PrimaryGroupID   $GID
sudo dscl . -create /Users/$TARGETUSER NFSHomeDirectory /Users/$TARGETUSER

sudo cp -a /System/Library/User\ Template/Japanese.lproj /Users/$TARGETUSER
chown -R $TARGETUSER\:staff /Users/$TARGETUSER
chmod 701 /Users/$TARGETUSER
sudo dscl . -passwd /Users/$TARGETUSER $PASSWORD

# このユーザに管理者権限を与える
sudo dscl . -append /Groups/admin GroupMembership $TARGETUSER
