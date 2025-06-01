#!/usr/bin/env bash

# ---------------------------------------------------------------------------
#
# Description:  This script contains functions to manage symlinks
#
#
# Functions:
#   symlink_zshrc          - Symlinks the .zshrc file.
#   symlink_starship_toml  - Symlinks the starship.toml file.
#   symlink_ghostty_config - Symlinks the ghostty.config file.
#   symlink_nvim_config    - Symlinks the nvim configuration directory.
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
  # The second argument (script_dir) is no longer used with the updated error message.
  if [ ! -e "${source_file}" ]; then # Changed -f to -e to allow files, directories, etc.
    echo "ERROR: Source '${source_file}' not found. Please ensure it exists at the specified path." >&2
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
  local backup_file
  # Check if anything exists at the target path that isn't the correct symlink (already handled)
  # and isn't a directory (already handled).
  if [ -e "${target_path}" ] || [ -L "${target_path}" ]; then
    backup_file="${target_path}.bak-$(date +%Y%m%d-%H%M%S)"
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

# Helper function to ensure the directory for the target symlink exists.
# Arguments:
#   $1: Path to the target symlink.
# Returns: 0 if directory exists or was created successfully, 1 otherwise.
_ensure_target_directory_exists() {
  local target_path="$1"
  local target_dir
  target_dir=$(dirname "${target_path}")

  if [ ! -d "${target_dir}" ]; then
    echo "Target directory '${target_dir}' does not exist. Creating it..."
    if ! mkdir -p "${target_dir}"; then
      echo "ERROR: Failed to create target directory '${target_dir}'." >&2
      return 1
    fi
  fi
  return 0
}

# Private helper function to process the symlinking for a given file.
# Arguments:
#   $1: Source filename (e.g., ".zshrc", "starship.toml") expected to be in the script's directory.
#   $2: Absolute path for the target symlink (e.g., "${HOME}/.zshrc").
# Returns: 0 if symlinking was successful or not needed, 1 on error.
_process_symlink() {
  local source_filename_in_script_dir="$1"
  local target_symlink_path="$2"
  local SCRIPT_DIR
  SCRIPT_DIR="$(_get_script_dir)"

  local full_source_path="${SCRIPT_DIR}/${source_filename_in_script_dir}"

  # Check if the source file actually exists.
  if ! _check_source_file_exists "${full_source_path}"; then # Removed SCRIPT_DIR argument
    return 1
  fi

  # Ensure the target directory exists.
  if ! _ensure_target_directory_exists "${target_symlink_path}"; then
    return 1
  fi
  # The _check_target_is_not_directory check was removed.
  # _backup_existing_target will handle cases where target_symlink_path is an existing directory.
  # Check if the symlink already exists and points to the correct source.
  if _is_symlink_up_to_date "${target_symlink_path}" "${full_source_path}"; then
    return 0 # Nothing to do
  fi

  # If the target exists (as a file or a different symlink), back it up.
  if ! _backup_existing_target "${target_symlink_path}"; then
    return 1 # Backup failed
  fi

  # Create the symbolic link.
  # The return status of _create_symbolic_link will be the return status of this function.
  _create_symbolic_link "${full_source_path}" "${target_symlink_path}"
}

# Function to symlink the .zshrc file from this script's directory
# to the user's home directory (~/.zshrc).
# It composes several helper functions to perform specific tasks like
# path resolution, validation, backup, and symlink creation.
#
# It assumes that the source .zshrc file (the one to be linked)
# is located in the same directory as this symlink.sh script.
symlink_zshrc() {
  local TARGET_ZSHRC="${HOME}/.zshrc"
  _process_symlink "dotfiles/.zshrc" "${TARGET_ZSHRC}"
}

# Function to symlink the starship.toml file from this script's directory
# to the user's config directory (~/.config/starship.toml).
# It assumes that the source starship.toml file (the one to be linked)
# is located in the same directory as this symlink.sh script.
symlink_starship_toml() {
  local TARGET_STARSHIP_TOML="${HOME}/.config/starship.toml"
  _process_symlink "starship.toml" "${TARGET_STARSHIP_TOML}"
}

# Function to symlink the ghostty.config file from this script's directory
# to the user's Ghostty application support directory.
# It assumes that the source ghostty.config file (the one to be linked)
# is located in the same directory as this symlink.sh script.
symlink_ghostty_config() {
  local TARGET_GHOSTTY_CONFIG="${HOME}/Library/Application Support/com.mitchellh.ghostty/config"
  _process_symlink "ghostty.config" "${TARGET_GHOSTTY_CONFIG}"
}

# Function to symlink the nvim configuration directory from this script's directory
# to the user's .config directory (/Users/Worker/.config/nvim).
# It assumes that the source nvim configuration (the one to be linked)
# is a directory named 'nvim' located in the same directory as this symlink.sh script.
symlink_nvim_config() {
  local TARGET_NVIM_CONFIG="${HOME}/.config/nvim"
  _process_symlink "nvim" "${TARGET_NVIM_CONFIG}"
}

# Function to symlink the .gitconfig file from this script's directory
# (specifically from the 'dotfiles' subdirectory) to the user's home directory (~/.gitconfig).
# It assumes that the source .gitconfig file (the one to be linked)
# is located in 'dotfiles/.gitconfig' relative to this symlink.sh script.
symlink_gitconfig() {
  local TARGET_GITCONFIG="${HOME}/.gitconfig"
  _process_symlink "dotfiles/.gitconfig" "${TARGET_GITCONFIG}"
}

symlink_zshrc
symlink_starship_toml
symlink_ghostty_config
symlink_nvim_config
symlink_gitconfig
