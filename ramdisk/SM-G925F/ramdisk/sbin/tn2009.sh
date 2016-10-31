#!/system/bin/sh


BB=/system/xbin/busybox;


# Mount root as RW to apply tweaks and settings
$BB mount -t rootfs -o remount,rw rootfs
$BB mount -o remount,rw /system


# Set SELinux permissive by default
setenforce 0


# Set correct r/w permissions for LMK parameters
$BB chmod 666 /sys/module/lowmemorykiller/parameters/cost;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/adj;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/minfree;


# Disable rotational storage for all blocks
# We need faster I/O so do not try to force moving to other CPU cores (dorimanx)
for i in /sys/block/*/queue; do
		echo "0" > "$i"/rotational
        echo "2" > "$i"/rq_affinity
done


# Allow untrusted apps to read from debugfs (mitigate SELinux denials)
if [ -e /su/lib/libsupol.so ]; then
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app sysfs_devices_system_iosched file { open read getattr }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file dir { search r_file_perms r_dir_perms }" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file file { r_file_perms r_dir_perms }" \
	"allow system_server { rootfs resourcecache_data_file } dir { open read write getattr add_name setattr create remove_name rmdir unlink link }" \
	"allow system_server resourcecache_data_file file { open read write getattr add_name setattr create remove_name unlink link }" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow drmserver theme_data_file file r_file_perms" \
	"allow zygote system_file file write" \
	"allow atfwd property_socket sock_file write" \
	"allow untrusted_app sysfs_display file { open read write getattr add_name setattr remove_name }" \
	"allow debuggerd app_data_file dir search" \
	"allow sensors diag_device chr_file { read write open ioctl }" \
	"allow sensors sensors capability net_raw" \
	"allow init kernel security setenforce" \
	"allow netmgrd netmgrd netlink_xfrm_socket nlmsg_write" \
	"allow netmgrd netmgrd socket { read write open ioctl }"
fi;


# Init.d
if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;
if [ "$($BB mount | grep system | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /system;
fi;
if [ ! -d /system/etc/init.d ]; then
	mkdir -p /system/etc/init.d/;
	chown -R root.root /system/etc/init.d;
	chmod 777 /system/etc/init.d/;
	chmod 777 /system/etc/init.d/*;
fi;
$BB run-parts /system/etc/init.d


$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro /system
$BB mount -o remount,rw /data


# Remove knox
cd /system

rm -rf *app/BBCAgent*
rm -rf *app/Bridge*
rm -rf *app/ContainerAgent*
rm -rf *app/ContainerEventsRelayManager*
rm -rf *app/DiagMonAgent*
rm -rf *app/ELMAgent*
rm -rf *app/FotaClient*
rm -rf *app/FWUpdate*
rm -rf *app/FWUpgrade*
rm -rf *app/HLC*
rm -rf *app/KLMSAgent*
rm -rf *app/*Knox*
rm -rf *app/*KNOX*
rm -rf *app/LocalFOTA*
rm -rf *app/RCPComponents*
rm -rf *app/SecKids*
rm -rf *app/SecurityLogAgent*
rm -rf *app/SPDClient*
rm -rf *app/SyncmlDM*
rm -rf *app/UniversalMDMClient*
rm -rf container*

