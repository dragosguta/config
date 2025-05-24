#!/usr/bin/env bash

# ---------------------------------------------------------------------------
#
# Description:  This script contains functions to manage symlinks for
#               dotfiles.
#
# Functions:
#   symlink_zshrc - Symlinks the .zshrc file.
#
# ---------------------------------------------------------------------------

# Function to symlink the .zshrc file from this script's directory
# to the user's home directory (~/.zshrc).
#
# It assumes that the source .zshrc file (the one to be linked)
# is located in the same directory as this symlink.sh script.
symlink_zshrc() {
  # Determine the absolute path to the directory where this script is located.
  # This is used to reliably find the source .zshrc file, even if the
  # script is called from a different directory.
  local SCRIPT_DIR
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

  local SOURCE_ZSHRC="${SCRIPT_DIR}/.zshrc"
  local TARGET_ZSHRC="${HOME}/.zshrc"

  echo "Preparing to symlink Zsh configuration..."
  echo "Source: ${SOURCE_ZSHRC}"
  echo "Target: ${TARGET_ZSHRC}"

  # Check if the source .zshrc file actually exists.
  if [ ! -f "${SOURCE_ZSHRC}" ]; then
    echo "Error: Source file '${SOURCE_ZSHRC}' not found."
    echo "Please ensure that a '.zshrc' file exists in the same directory as this script (${SCRIPT_DIR})."
    return 1
  fi

  # Check if the target is already a symlink pointing to the correct source.
  if [ -L "${TARGET_ZSHRC}" ]; then
    if [ "$(readlink "${TARGET_ZSHRC}")" = "${SOURCE_ZSHRC}" ]; then
      echo "Symlink already exists and is correct: '${TARGET_ZSHRC}' -> '${SOURCE_ZSHRC}'"
      return 0
    else
      echo "Warning: '${TARGET_ZSHRC}' is a symlink but points to a different location: $(readlink "${TARGET_ZSHRC}")"
      echo "It will be replaced."
    fi
  elif [ -f "${TARGET_ZSHRC}" ]; then
    echo "Warning: '${TARGET_ZSHRC}' exists as a regular file. It will be replaced by the symlink."
    # Optionally, you could back up the existing file here:
    # local BACKUP_FILE="${TARGET_ZSHRC}.bak-$(date +%Y%m%d-%H%M%S)"
    # echo "Backing up existing file to '${BACKUP_FILE}'"
    # mv "${TARGET_ZSHRC}" "${BACKUP_FILE}" || { echo "Error: Failed to back up existing file."; return 1; }
  elif [ -d "${TARGET_ZSHRC}" ]; then
    echo "Error: '${TARGET_ZSHRC}' exists as a directory. Cannot replace a directory with a symlink to a file using this script."
    return 1
  fi

  # Create the symbolic link.
  # -s: creates a symbolic link.
  # -f: forces the creation. If the target file already exists, it will be removed.
  echo "Creating symlink: '${TARGET_ZSHRC}' -> '${SOURCE_ZSHRC}'"
  if ln -sf "${SOURCE_ZSHRC}" "${TARGET_ZSHRC}"; then
    echo "Symlink created successfully."
  else
    echo "Error: Failed to create symlink."
    # Attempt to provide more context on failure if possible (e.g. permissions)
    # This part can be expanded if more detailed error reporting is needed.
    return 1
  fi

  return 0
}

symlink_zshrc
