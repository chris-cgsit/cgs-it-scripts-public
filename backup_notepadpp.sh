#!/usr/bin/env bash
###############################################################################
#  Backup Script for Notepad++ Unsaved Files and Session State
#
#  Description:
#    - Creates timestamped backups of Notepad++ unsaved tabs ("new 1", etc.)
#      and session.xml into a mounted Google Drive folder.
#    - Keeps only the latest MAX_BACKUPS copies (rotation).
#    - The newest backup is stored as a folder unless KEEP_AS_ZIP_ONLY=true.
#    - Older backups are zipped for storage efficiency.
#    - Includes retry-safe deletion for Google Drive sync delays.
#    - Logs each run to $DST_ROOT/logs/backup_YYYY-MM-DD.log
#
#  ┌─────────────────────────────────────────────────────────────────────────┐
#  │   © 2025 CGS IT Solutions GmbH                                          │
#  │   License: Creative Commons Attribution-NonCommercial 4.0 International │
#  │   (CC BY-NC 4.0)                                                        │
#  │   https://creativecommons.org/licenses/by-nc/4.0/                       │
#  └─────────────────────────────────────────────────────────────────────────┘
#
#  You are free to:
#    ✔ Share — copy and redistribute the material in any medium or format
#    ✔ Adapt — remix, transform, and build upon the material
#
#  Under the following terms:
#    ❌ NonCommercial — you may not use the material for commercial purposes.
#    ✔ Attribution — you must give appropriate credit.
###############################################################################

set -euo pipefail

# ======== Config (edit these) ========
BACKUP_BASENAME="NotepadPP_Backup"                 # Prefix for backups
DST_ROOT="I:/Meine Ablage/980_backup_np_pp"        # Google Drive destination
MAX_BACKUPS=5                                      # Keep newest N (folder+zips)
KEEP_AS_ZIP_ONLY=false                             # true => newest also zipped
ZIP_CMD=(zip -rq)                                  # MINGW64 zip command
LOCAL_STAGE_ROOT="/c/Users/$USERNAME/AppData/Local/Temp/notepadpp_stage"  # local staging
# =====================================

# --- Logging setup ---
mkdir -p "$DST_ROOT" "$LOCAL_STAGE_ROOT" "$DST_ROOT/logs"
LOG_FILE="$DST_ROOT/logs/backup_$(date +%Y-%m-%d).log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "================ $(date '+%Y-%m-%d %H:%M:%S') ================"

# --- Pre-flight checks ---
if ! command -v tasklist >/dev/null 2>&1; then
  echo "❌ 'tasklist' not found. Run in Git Bash on Windows."
  exit 1
fi
if ! command -v zip >/dev/null 2>&1; then
  echo "❌ 'zip' not found in PATH."
  exit 1
fi

# --- 1) Check if Notepad++ is running ---
if tasklist | grep -iq "notepad++.exe"; then
  echo "⚠ Notepad++ is still running. Please close it before backup."
  exit 1
fi
echo "✔ Notepad++ is not running."

# --- 2) Source paths ---
APPDATA_WIN=$(cygpath "$APPDATA")
SRC_DIR="$APPDATA_WIN/Notepad++"
SRC_BACKUP="$SRC_DIR/backup"
SRC_SESSION="$SRC_DIR/session.xml"

# --- 3) Create local staging folder for this run ---
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
RUN_NAME="${BACKUP_BASENAME}_$TIMESTAMP"
STAGE_DIR="$LOCAL_STAGE_ROOT/$RUN_NAME"
mkdir -p "$STAGE_DIR"

# --- 4) Copy files into stage ---
if [ -d "$SRC_BACKUP" ]; then
  cp -r "$SRC_BACKUP" "$STAGE_DIR/"
  echo "✔ Copied unsaved files from: $SRC_BACKUP"
else
  echo "⚠ No Notepad++ backup folder found at: $SRC_BACKUP"
fi
if [ -f "$SRC_SESSION" ]; then
  cp "$SRC_SESSION" "$STAGE_DIR/"
  echo "✔ Copied session.xml"
else
  echo "⚠ session.xml not found at: $SRC_SESSION"
fi
echo "✅ Staged backup at: $STAGE_DIR"

# --- Helpers ---
safe_remove_dir () {
  local dir="$1"
  local tries=0
  while [ $tries -lt 5 ]; do
    rm -rf -- "$dir" 2>/dev/null && return 0
    tries=$((tries+1))
    echo "⚠ Directory busy, retrying removal ($tries/5)..."
    sleep 1
  done
  if command -v cmd.exe >/dev/null 2>&1; then
    local winpath
    winpath=$(cygpath -w "$dir")
    cmd.exe /C "rmdir /s /q \"$winpath\"" >/dev/null 2>&1 || true
  fi
  rm -rf -- "$dir" 2>/dev/null || true
}

zip_dir_in_place () {
  local dir_path="$1"
  local base="$(basename "$dir_path")"
  local parent="$(dirname "$dir_path")"
  (cd "$parent" && "${ZIP_CMD[@]}" "${base}.zip" "$base")
}

# --- 5) Produce deliverable(s) in stage, then move to Google Drive ---
if [ "$KEEP_AS_ZIP_ONLY" = true ]; then
  zip_dir_in_place "$STAGE_DIR"
  mv -f "${STAGE_DIR}.zip" "$DST_ROOT/"
  safe_remove_dir "$STAGE_DIR"
  NEWEST_PATH="$DST_ROOT/${RUN_NAME}.zip"
  echo "📦 Newest backup archived: $NEWEST_PATH"
else
  DEST_NEW_DIR="$DST_ROOT/$RUN_NAME"
  mv -f "$STAGE_DIR" "$DEST_NEW_DIR"
  NEWEST_PATH="$DEST_NEW_DIR"
  echo "📂 Newest backup folder: $NEWEST_PATH"
fi

# --- 6) Rotation on Google Drive (name-sorted, newest first) ---
mapfile -t NAMES < <(ls -1 "$DST_ROOT" 2>/dev/null | grep -E "^${BACKUP_BASENAME}_" | sort -r)

COUNT=0
for name in "${NAMES[@]}"; do
  path="$DST_ROOT/$name"
  COUNT=$((COUNT+1))
  if [ $COUNT -eq 1 ]; then
    continue  # newest kept as-is
  elif [ $COUNT -le $MAX_BACKUPS ]; then
    if [ -d "$path" ]; then
      echo "↪ Zipping older folder: $path"
      zip_dir_in_place "$path"
      safe_remove_dir "$path"
    fi
  else
    echo "🗑 Removing old: $path"
    if [ -d "$path" ]; then
      safe_remove_dir "$path"
    else
      rm -f -- "$path" 2>/dev/null || true
    fi
  fi
done

if [ "$KEEP_AS_ZIP_ONLY" = true ]; then
  echo "🧹 Rotation complete. Kept $MAX_BACKUPS zips (newest also zipped)."
else
  echo "🧹 Rotation complete. Kept 1 folder (newest) + $((MAX_BACKUPS-1)) zips."
fi

echo "📄 Log file: $LOG_FILE"
