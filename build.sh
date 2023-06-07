python --version
time repo init -u https://github.com/PixelExperience/manifest -b thirteen-plus --depth=1 --git-lfs -g default,-mips,-darwin,-notdefault
git clone https://github.com/NopeNopeGuy/local_manifests.git .repo/local_manifests -b ruby
echo "repo init"
time repo sync -j32 -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync || repo sync -j4 -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync
git lfs install
repo forall -c 'git lfs pull'
echo "sync complete"
rm -rf vendor/aosp
rm -rf packages/apps/Settings
rm -rf packages/apps/Updates
git clone https://github.com/NopeNopeGuy/packages_apps_Settings packages/apps/Settings -b thirteen-plus
git clone https://github.com/NopeNopeGuy/packages_apps_Updates packages/apps/Updates -b thirteen
git clone https://github.com/NopeNopeGuy/vendor_aosp vendor/aosp -b thirteen-plus
export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1
export CCACHE_COMPRESSLEVEL=5
ccache -M 30G
ccache -o compression=true 
ccache -z
export ALLOW_MISSING_DEPENDENCIES=true
timeout 90m bash -c "source build/envsetup.sh && lunch aosp_whyred-userdebug && mka bacon -j16" || exit 0
