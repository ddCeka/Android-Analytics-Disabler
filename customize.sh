ui_print "- Start customize.sh script"

# Use Magisk's built-in grep_prop helper to cleanly extract the version string
VERSION=$(grep_prop version "$MODPATH/module.prop")
ui_print "- Installing Analytics Disabler $VERSION"

# Leave REPLACE empty since you are only adding a binary to /system/bin
REPLACE=""

# Permissions
set_permissions() {
    ui_print "- Setting permissions for files in system/bin"
    # Recursively set root:shell (0:2000), 0755 directory/file permissions, and proper SELinux context
    set_perm_recursive "$MODPATH/system/bin" 0 2000 0755 0755 u:object_r:system_file:s0
}

set_permissions

ui_print "- End customize.sh script"
