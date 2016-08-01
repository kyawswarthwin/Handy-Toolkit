export PATH=/data/local/tmp:$PATH

sqlite3 "/data/data/com.android.providers.settings/databases/settings.db" "UPDATE system SET value='0' WHERE name='lock_pattern_autolock';UPDATE secure SET value='0' WHERE name='lock_pattern_autolock';UPDATE secure SET value='65536' WHERE name='lockscreen.password_type';UPDATE secure SET value='0' WHERE name='lockscreen.password_type_alternate';"
rm /data/system/gesture.key
rm /data/system/password.key
rm /data/system/locksettings.db*
