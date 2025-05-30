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

# Helper function to get the absolute path to the directory where this script is located.
_get_script_dir() {
  # Uses BASH_SOURCE[0] to refer to this script file.
  # cd to its directory, then pwd to get the absolute path.
  # &>/dev/null suppresses output from cd.
  echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
}

# Helper function to check if the source file exists and is a regular file.
# Arguments:
#   $1: Path to the source file.
#   $2: Script directory (for error message context).
# Returns: 0 if exists, 1 otherwise.
_check_source_file_exists() {
  local source_file="$1"
  local script_dir="$2"
  if [ ! -f "${source_file}" ]; then
    echo "ERROR: Source file '${source_file}' not found." >&2
    echo "Please ensure that a '.zshrc' file exists in the script directory (${script_dir})." >&2
    return 1
  fi
  return 0
}

# Helper function to check if the target path is a directory.
# Arguments:
#   $1: Path to the target.
# Returns: 0 if not a directory, 1 if it is a directory (which is an error condition).
_check_target_is_not_directory() {
  local target_path="$1"
  if [ -d "${target_path}" ]; then
    echo "ERROR: Target '${target_path}' exists as a directory. Cannot replace with a symlink." >&2
    return 1
  fi
  return 0
}

# Helper function to check if the symlink at target_path already exists and points to source_path.
# Arguments:
#   $1: Path to the target symlink.
#   $2: Expected path of the source file.
# Returns: 0 if symlink is correct and up-to-date, 1 otherwise.
_is_symlink_up_to_date() {
  local target_symlink="$1"
  local expected_source="$2"
  if [ -L "${target_symlink}" ] && [ "$(readlink "${target_symlink}")" = "${expected_source}" ]; then
    echo "Symlink '${target_symlink}' already exists and is correct."
    return 0 # Symlink is correct
  fi
  return 1 # Symlink is not correct or does not exist as a symlink
}

# Helper function to back up an existing file or symlink at the target path.
# Arguments:
#   $1: Path to the target file/symlink to back up.
# Returns: 0 if backup was successful or not needed, 1 on backup failure.
_backup_existing_target() {
  local target_path="$1"
  # Check if anything exists at the target path that isn't the correct symlink (already handled)
  # and isn't a directory (already handled).
  if [ -e "${target_path}" ] || [ -L "${target_path}" ]; then
    local backup_file="${target_path}.bak-$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing '${target_path}' to '${backup_file}'..."
    if ! mv -f "${target_path}" "${backup_file}"; then
      echo "ERROR: Failed to back up '${target_path}' to '${backup_file}'." >&2
      return 1
    fi
  fi
  return 0 # Backup successful or not needed
}

# Helper function to create the symbolic link.
# Arguments:
#   $1: Path to the source file.
#   $2: Path for the target symlink.
# Returns: 0 if symlink creation was successful, 1 otherwise.
_create_symbolic_link() {
  local source_path="$1"
  local target_path="$2"
  echo "Creating symlink: '${target_path}' -> '${source_path}'..."
  if ln -sf "${source_path}" "${target_path}"; then
    echo "Symlink created successfully."
  else
    echo "ERROR: Failed to create symlink '${target_path}'." >&2
    return 1
  fi
  return 0
}

# Function to symlink the .zshrc file from this script's directory
# to the user's home directory (~/.zshrc).
# It composes several helper functions to perform specific tasks like
# path resolution, validation, backup, and symlink creation.
#
# It assumes that the source .zshrc file (the one to be linked)
# is located in the same directory as this symlink.sh script.
symlink_zshrc() {
  local SCRIPT_DIR
  SCRIPT_DIR="$(_get_script_dir)" # Use helper to get script directory

  local SOURCE_ZSHRC="${SCRIPT_DIR}/.zshrc"
  local TARGET_ZSHRC="${HOME}/.zshrc"

  # Check if the source .zshrc file actually exists.
  if ! _check_source_file_exists "${SOURCE_ZSHRC}" "${SCRIPT_DIR}"; then
    return 1
  fi

  # Check if the target is a directory, which we cannot replace.
  if ! _check_target_is_not_directory "${TARGET_ZSHRC}"; then
    return 1
  fi

  # Check if the symlink already exists and points to the correct source.
  if _is_symlink_up_to_date "${TARGET_ZSHRC}" "${SOURCE_ZSHRC}"; then
    return 0 # Nothing to do
  fi

  # If the target exists (as a file or a different symlink), back it up.
  if ! _backup_existing_target "${TARGET_ZSHRC}"; then
    return 1 # Backup failed
  fi

  # Create the symbolic link.
  if ! _create_symbolic_link "${SOURCE_ZSHRC}" "${TARGET_ZSHRC}"; then
    return 1 # Symlink creation failed
  fi

  return 0
}

symlink_zshrc
