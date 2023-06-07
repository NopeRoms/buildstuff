CCACHE_FILE="$CIRRUS_BRANCH""_ccache.tar.gz"

cd /tmp

# Compress function with pigz for faster compression
com () 
{ 
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}

time com ccache 1 # Compression level 1, its enough

# Rename file before uploading
mv ccache.tar.gz $CCACHE_FILE

time rclone copy $CCACHE_FILE drive: -P # aosp is my rclone config name (first line without [] of ~/.config/rclone/rclone.conf file from rclone setup done on pc)

#
