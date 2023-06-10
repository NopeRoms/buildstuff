python --version
time repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --depth=1 --git-lfs -g default,-mips,-darwin,-notdefault
echo "repo init"
time repo sync -j32 -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync || repo sync -j4 -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync
git lfs install
repo forall -c 'git lfs pull'
echo "sync complete"
git clone https://github.com/NopeNopeGuy/device_xiaomi_whyred device/xiaomi/whyred --depth=1 -b thirteen-lineage
git clone https://gitlab.pixelexperience.org/android/vendor-blobs/vendor_xiaomi_whyred.git vendor/xiaomi/whyred --depth=1
git clone https://gitlab.pixelexperience.org/android/vendor-blobs/vendor_xiaomi_sdm660-common.git vendor/xiaomi/sdm660-common --depth=1
git clone https://github.com/NopeNopeGuy/device_xiaomi_sdm660-common.git device/xiaomi/sdm660-common --depth=1 -b thirteen-lineage
git clone https://github.com/PixelExperience-Devices/kernel_xiaomi_sdm660.git kernel/xiaomi/sdm660 --depth=1
git clone https://github.com/PixelExperience/hardware_xiaomi hardware/xiaomi --depth=1
rm -rf packages/modules/Permission
rm -rf frameworks/base
git clone https://github.com/NopeNopeGuy/android_frameworks_base.git frameworks/base --depth=1 -b lineage-20.0
git clone https://github.com/NopeNopeGuy/android_packages_modules_Permission.git packages/modules/Permission --depth=1 -b lineage-20.0
export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export CCACHE_COMPRESSLEVEL=5
ccache -M 30G
ccache -o compression=true 
ccache -z
export ALLOW_MISSING_DEPENDENCIES=true
timeout 90m bash -c "source build/envsetup.sh && lunch lineage_whyred-userdebug && mka bacon -j16" || exit 0
