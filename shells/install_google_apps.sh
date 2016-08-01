export PATH=/data/local/tmp:$PATH

busybox mount -o remount,rw /system

for i in `cat /data/local/tmp/gapps.lst`; do
    busybox chattr -i $i
    rm $i
done

busybox tar -xvzf /data/local/tmp/gapps.tar.gz
