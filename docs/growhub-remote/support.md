# Growhub Remote support

Growhub Remote is a free, independent LAN control app for NIWA Growhub/Growhub+
controllers already running Growhub Community Edition firmware. It does not work
with stock NIWA cloud firmware or install CE firmware for the first time.

Connect your iPhone or iPad to the same Wi-Fi LAN and allow Local Network access.
Refresh to discover controllers, or use + to enter a controller address. Guest
Wi-Fi, VLAN isolation and VPN routing can prevent discovery. For subnets larger
than /20 the app probes the local /24 neighborhood plus saved addresses; add
other controllers by address. IPv6-only discovery is not currently supported.

Released CE firmware may have a shared Auto/Manual mode for all four outlets.
Manual preserves the current outputs and pauses schedules. Use Resume schedules
to return to Auto. Independent outlet modes require compatible installed firmware.
Full controls opens the controller's local page for schedules and settings.

Use Help and demo → Explore demo to try the native controls without hardware.
Demo controllers never send network requests or operate physical equipment.

For help, email support@deep6gear.com with your app/iOS and CE firmware versions,
the action you tried, and the error message. Do not send Wi-Fi passwords.

Published by Plongee6 LLC. Not affiliated with or endorsed by NIWA or the Growhub
CE maintainers. The CE firmware is a separate open-source project:
https://github.com/Shrug-Lord/growhub-ce-firmware
