#!/bin/sh
# Launch a Windows game from the appended /game under Xvfb and Proton.
set -eu

: "${PROTON_DIR:=/opt/proton}"
: "${STEAM_COMPAT_DATA_PATH:=$HOME/.proton}"
: "${STEAM_COMPAT_CLIENT_INSTALL_PATH:=$HOME/.steam}"
: "${SCREEN:=1920x1080x24}"
: "${DESKTOP:=1920x1080}"

# The lavapipe ICD filename carries the arch on Debian and not on Arch, so it is
# globbed rather than hardcoded.
if [ -z "${VK_ICD_FILENAMES:-}" ]; then
  for icd in /usr/share/vulkan/icd.d/lvp_icd*.json; do
    [ -e "$icd" ] && VK_ICD_FILENAMES="$icd" && break
  done
  export VK_ICD_FILENAMES
fi

mkdir -p "$STEAM_COMPAT_DATA_PATH" "$STEAM_COMPAT_CLIENT_INSTALL_PATH"
export STEAM_COMPAT_DATA_PATH STEAM_COMPAT_CLIENT_INSTALL_PATH PROTON_DIR DESKTOP

# Without the virtual desktop Unity crashes one frame after "<RI> Input initialized"
# on a bare Xvfb. explorer detaches, so wineserver -w is what holds Xvfb open.
exec xvfb-run -a -s "-screen 0 $SCREEN" sh -c '
  "$PROTON_DIR/proton" run explorer "/desktop=game,$DESKTOP" "$@"
  WINEPREFIX="$STEAM_COMPAT_DATA_PATH/pfx" exec "$PROTON_DIR/files/bin/wineserver" -w
' _ "$@"
