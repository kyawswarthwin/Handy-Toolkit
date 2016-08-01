export PATH=/data/local/tmp:$PATH

busybox mount -o remount,rw /system

dd if=/data/local/tmp/busybox of=/system/xbin/busybox
chown root.shell /system/xbin/busybox
chmod 04755 /system/xbin/busybox
/system/xbin/busybox --install -s /system/xbin
