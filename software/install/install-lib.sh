# Common installer library for power-installer
# Provides: detect_os, require_cmds, backup_file, run_cmd, confirm

# Caller should set DRY_RUN=1 for a dry run, YES=1 to skip confirmations

detect_os() {
  local uname out
  if command -v lsb_release >/dev/null 2>&1; then
    out=$(lsb_release -si 2>/dev/null || true)
    case "${out,,}" in
      ubuntu|debian) echo "debian"; return ;;
      arch) echo "arch"; return ;;
      "linuxmint") echo "debian"; return ;;
    esac
  fi
  uname=$(uname -s)
  case "$uname" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "unknown" ;;
  esac
}

require_cmds() {
  local miss=()
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      miss+=("$cmd")
    fi
  done
  if [ ${#miss[@]} -ne 0 ]; then
    echo "Missing required commands: ${miss[*]}" >&2
    return 2
  fi
  return 0
}

run_cmd() {
  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    echo "DRY-RUN: $*"
  else
    echo "+ $*"
    eval "$@"
  fi
}

_backup_dir_base() {
  echo "${BACKUP_DIR:-$HOME/.power-installer-backups}"
}

backup_file() {
  local file="$1"
  if [ ! -e "$file" ]; then
    return 0
  fi
  local ts backup_dir base
  ts=$(date +"%Y%m%d-%H%M%S")
  base="$(_backup_dir_base)/$ts"
  mkdir -p "$base"
  echo "Backing up $file -> $base/"
  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    echo "DRY-RUN: mv '$file' '$base/'"
  else
    mv "$file" "$base/"
  fi
}

copy_if_needed() {
  # copy src -> dst only if dst does not exist or differs from src
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    if cmp -s "$src" "$dst" 2>/dev/null; then
      echo "Unchanged: $dst"
      return 0
    else
      backup_file "$dst"
    fi
  fi
  run_cmd "cp -a '$src' '$dst'"
}

rsync_dir_if_needed() {
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    # rudimentary check: compare checksums of tree sizes
    if diff -r "$src" "$dst" >/dev/null 2>&1; then
      echo "Unchanged: $dst"
      return 0
    else
      backup_file "$dst"
    fi
  fi
  run_cmd "rsync -a --delete '$src/' '$dst/'"
}

confirm_or_die() {
  local prompt_text="$1"
  if [ "${YES:-0}" -eq 1 ]; then
    return 0
  fi
  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    echo "DRY-RUN: would ask: $prompt_text"
    return 0
  fi
  read -r -p "$prompt_text [y/N]: " resp
  case "${resp,,}" in
    y|yes) return 0 ;;
    *) echo "Aborted."; return 1 ;;
  esac
}

# verify_command <cmd> [<regex>] [<version-cmd>]
# - checks command exists; if <regex> provided, runs <version-cmd> (defaults to "<cmd> --version") and checks output matches regex
verify_command() {
  local cmd="$1"
  local regex="${2:-}"
  local ver_cmd="${3:-$cmd --version}"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd not found" >&2
    return 2
  fi

  if [ -n "$regex" ]; then
    local out
    out=$(eval "$ver_cmd" 2>&1 || true)
    if ! echo "$out" | grep -E -q "$regex"; then
      echo "WARNING: $cmd version check failed. Expected regex: $regex; output: ${out%%$'\n'*}" >&2
      return 3
    fi
    echo "$cmd OK: ${out%%$'\n'*}"
  else
    echo "$cmd present"
  fi
  return 0
}
