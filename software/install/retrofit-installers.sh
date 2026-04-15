#!/usr/bin/env bash
set -euo pipefail
# Retrofit installers: backup and wrap shell scripts under software/ to source install-lib.sh
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-"$HOME"/.power-installer-backups/retrofit-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$BACKUP_DIR"
echo "Backup dir: $BACKUP_DIR"

# Find files with a shebang under software/
mapfile -t files < <(grep -RIl --line-number '^#!' "$ROOT/software" || true)

for f in "${files[@]}"; do
  # skip this script and install-lib
  if [[ "$f" == *"install/install-lib.sh"* ]] || [[ "$f" == *"retrofit-installers.sh"* ]]; then
    continue
  fi
  # skip if already wrapped
  if grep -q "Wrapped by power-installer" "$f" 2>/dev/null; then
    echo "Skipping already wrapped: $f"
    continue
  fi
  echo "Wrapping: $f"
  # create backup path
  rel="${f#"$ROOT"/}"
  dest_backup="$BACKUP_DIR/$rel"
  mkdir -p "$(dirname "$dest_backup")"
  cp -a "$f" "$dest_backup"
  # move original to .orig
  orig="$f.orig"
  mv "$f" "$orig"

  dir="$(dirname "$f")"
  base="$(basename "$f")"
  orig_base="$base.orig"

  cat > "$f" <<EOF
#!/usr/bin/env bash
# Wrapped by power-installer: sources install-lib and enforces --dry-run/--yes
SCRIPT_DIR="
$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
"
LIB="$SCRIPT_DIR/install/install-lib.sh"
[ -f "$LIB" ] && source "$LIB"
DRY_RUN=
${DRY_RUN:-0}
YES=
${YES:-0}

# parse wrapper flags
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --yes|-y) YES=1; shift ;;
    --) shift; break ;;
    *) break ;;
  esac
done
export DRY_RUN YES

# exec the original script (kept as $orig_base)
exec bash "$SCRIPT_DIR/$orig_base" "$@"
EOF
  chmod +x "$f"
done

echo "Retrofit complete. Backups in $BACKUP_DIR"
