#!/bin/bash
# Copyright (c) 2018-Present MongoDB Inc.

# shellcheck source=prepare-shell.sh
. "$(dirname "$0")/prepare-shell.sh"

(
  if [ "$PLATFORM_NAME" != windows ]; then
      exit 0
  fi

  PREFIX=mongodb-connector-odbc-"$MDBODBC_VER"-win-x86-64

  # clear MSI_BUILD_DIR
  rm -rf "$MSI_BUILD_DIR"
  mkdir -p "$MSI_BUILD_DIR"

  cd "$MSI_BUILD_DIR"

  # copy msi sources to current directory
  cp -R "$PROJECT_ROOT/mongodb-odbc-driver/installer/msi/"* ./

  # copy driver libraries to appropriate location
  cp "$DRIVERS_DIR"/* ./

  if [ "$PLATFORM_ARCH" = "64" ]; then
         arch="x64"
  else
         arch="x86"
  fi

  "$POWERSHELL" \
          -NoProfile \
          -NoLogo \
          -NonInteractive \
          -ExecutionPolicy ByPass \
          -File ./build-msi.ps1 \
          -Arch "$arch" \
          -VersionLabel "$MDBODBC_VER"

  # clear PKG_DIR
  rm -rf "$PKG_DIR"
  mkdir -p "$PKG_DIR"

  # copy the msi to PKG_DIR
  cp release.msi "$PKG_DIR"/mongodb-odbc.msi
) > $LOG_FILE 2>&1

print_exit_msg

