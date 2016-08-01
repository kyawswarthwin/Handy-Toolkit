export PATH=/data/local/tmp:$PATH

busybox mount -o remount,rw /system

for i in `ls -l /system/xbin | busybox grep "busybox" | busybox awk '{ print $6 }'`; do
    rm /system/xbin/$i
done

rm /system/xbin/busybox
