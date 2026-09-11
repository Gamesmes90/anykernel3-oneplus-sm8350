#!/system/bin/sh

KERNEL_TAG=1.4.0-a16-20260912
REPO=Gamesmes90/android_kernel_oneplus_sm8350
URL="https://github.com/Gamesmes90/android_kernel_oneplus_sm8350/releases/latest"

echo "Checking for updates..."

# Fetch
LATEST_TAG=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | cut -d '"' -f 4)

# Guard against empty API responses
if [ -z "$LATEST_TAG" ]; then
    echo "Error: Could not fetch the latest release from GitHub."
    exit 1
fi

# Helper: Converts "1.4.0-a16-20260912" into standard padded digits "000100040000001620260912"
normalize_version() {
    echo "$1" | sed 's/[^0-9]/ /g' | ( read -r a b c d e f; printf "%04d%04d%04d%04d%08d" "${a:-0}" "${b:-0}" "${c:-0}" "${d:-0}" "${e:-0}" )
}

# 1. Check for an exact match FIRST
if [ "$KERNEL_TAG" = "$LATEST_TAG" ]; then
    echo "No updates found."
    echo "Version:  $KERNEL_TAG"
else
    # 2. Normalize and sort standard strings (Supported by all Android versions)
    LOCAL_NUM=$(normalize_version "$KERNEL_TAG")
    REMOTE_NUM=$(normalize_version "$LATEST_TAG")

    HIGHEST_TAG=$(printf "%s %s\n%s %s\n" "$LOCAL_NUM" "$KERNEL_TAG" "$REMOTE_NUM" "$LATEST_TAG" | sort | tail -n1 | cut -d' ' -f2)

    # Safety net: If Android's shell pipe fails for any reason
    if [ -z "$HIGHEST_TAG" ]; then
        HIGHEST_TAG="$LATEST_TAG"
    fi
    
    # 3. Check if the latest remote tag is the highest
    if [ "$HIGHEST_TAG" = "$LATEST_TAG" ]; then
        echo "A new version is available!"
        echo "Local:  $KERNEL_TAG"
        echo "Remote: $LATEST_TAG"
        echo "Download here: $URL"
        am start --user 0 -a android.intent.action.VIEW -d "$URL"
    else
        echo "Notice: Local tag ($KERNEL_TAG) is newer than the remote release ($LATEST_TAG)."
    fi
fi