#!/system/bin/sh

# Re-enable all previously disabled components using the module's binary before Magisk deletes it
if [ -x "$MODPATH/system/bin/dss" ]; then
    # Create the flag file temporarily so dss doesn't exit on the first-time notice
    touch /data/.dss.init
    
    # Re-enable components for both user and system apps
    "$MODPATH/system/bin/dss" enable user >/dev/null 2>&1
    "$MODPATH/system/bin/dss" enable system >/dev/null 2>&1
fi

# Clean up the initialization flag created by dss
rm -f /data/.dss.init
