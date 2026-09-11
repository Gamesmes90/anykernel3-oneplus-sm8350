### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=### kernel-oneplus-sm8350 for lemonade/lemonadep ###
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus9Pro
device.name2=lemonadep
device.name3=OnePlus9ProTMO
device.name4=lemonadept
device.name5=OnePlus9
device.name6=lemonade
device.name7=OnePlus9TMO
device.name8=lemonadet
device.name9=OnePlus9VZW
device.name10=lemonadev
supported.versions=16
'; } # end properties

## trim partitions
fstrim -v /data;

### AnyKernel install

# boot shell variables
BLOCK=boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;
NO_VBMETA_PARTITION_PATCH=1;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
dump_boot;

write_boot;
## end boot install


# vendor_boot shell variables
BLOCK=vendor_boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;
NO_VBMETA_PARTITION_PATCH=1;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
dump_boot;

write_boot;
## end vendor_boot install

# Install custom boot script module if ksu is present
if [ -d /data/adb/ksu ]; then
    ui_print "- KernelSU detected, installing kernel tweaks module..."

    MODDIR="/data/adb/modules/kernel-tweaks"
    
    if [ -d $MODDIR ]; then
        ui_print "Module folder exists, updating..."
        rm -rf $MODDIR
    fi
    
    mkdir -p $MODDIR
  
    # Copy files
    cp ksu_module/* $MODDIR

    # Set permissions
    chmod 644 $MODDIR/module.prop
    chmod 755 $MODDIR/service.sh
    chmod 755 $MODDIR/config.sh
    chmod 755 $MODDIR/action.sh

    ui_print "Kernel Tweaks module installed!"
fi