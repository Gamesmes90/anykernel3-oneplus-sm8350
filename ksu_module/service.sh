#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/config.sh"

# wait until system is ready
sleep 15

# Enable double tap
echo ${ENABLE_DT2W} > /proc/touchpanel/double_tap_enable

if [ "$INPUT_BOOST" = "1" ]; then
    # Input boost configuration
    echo "0:1094400 1:0 2:0 3:0 4:0 5:0 6:0 7:0" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
    echo 500 > /sys/devices/system/cpu/cpu_boost/input_boost_ms
fi

# Log
echo "KernelSU tweaks applied" > /dev/kmsg