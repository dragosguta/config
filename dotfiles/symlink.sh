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
    echo "ERROR: Source file '${SOURCE_ZSHRC}' not found."
    echo "Please ensure that a '.zshrc' file exists in the same directory as this script (${SCRIPT_DIR})."
    return 1
  fi

  local perform_backup=false
  local backup_needed_message=""

  # Check the status of the target file/symlink
  if [ -L "${TARGET_ZSHRC}" ]; then # Target is a symlink
    if [ "$(readlink "${TARGET_ZSHRC}")" = "${SOURCE_ZSHRC}" ]; then
      echo "Symlink already exists and is correct: '${TARGET_ZSHRC}' -> '${SOURCE_ZSHRC}'"
      return 0 # Nothing to do
    else
      # Target is a symlink but points to the wrong location
      backup_needed_message="Warning: '${TARGET_ZSHRC}' is an existing symlink pointing to '$(readlink "${TARGET_ZSHRC}")'."
      perform_backup=true
    fi
  elif [ -f "${TARGET_ZSHRC}" ]; then # Target is a regular file
    backup_needed_message="Warning: '${TARGET_ZSHRC}' exists as a regular file."
    perform_backup=true
  elif [ -d "${TARGET_ZSHRC}" ]; then # Target is a directory
    echo "ERROR: '${TARGET_ZSHRC}' exists as a directory. Cannot replace a directory with a symlink to a file using this script."
    return 1
  fi
  # If none of the above, TARGET_ZSHRC does not exist, and perform_backup remains false.

  # Perform backup if needed
  if [ "$perform_backup" = true ]; then
    echo "${backup_needed_message}"
    local BACKUP_FILE="${TARGET_ZSHRC}.bak-$(date +%Y%m%d-%H%M%S)"
    echo "It will be backed up to '${BACKUP_FILE}' before being replaced by the new symlink."
    if mv -f "${TARGET_ZSHRC}" "${BACKUP_FILE}"; then
      echo "Backup of '${TARGET_ZSHRC}' to '${BACKUP_FILE}' successful."
    else
      echo "ERROR: Failed to back up '${TARGET_ZSHRC}' to '${BACKUP_FILE}'."
      return 1
    fi
  fi

  # Create the symbolic link.
  # -s: creates a symbolic link.
  # -f: forces the creation. If the target file already exists (it shouldn't if backup worked,
  #     or if it didn't exist initially), it will be removed.
  echo "Creating symlink: '${TARGET_ZSHRC}' -> '${SOURCE_ZSHRC}'"
  if ln -sf "${SOURCE_ZSHRC}" "${TARGET_ZSHRC}"; then
    echo "Symlink created successfully."
  else
    echo "ERROR: Failed to create symlink."
    # Attempt to provide more context on failure if possible (e.g. permissions)
    # This part can be expanded if more detailed error reporting is needed.
    return 1
  fi

  return 0
}

symlink_zshrc
