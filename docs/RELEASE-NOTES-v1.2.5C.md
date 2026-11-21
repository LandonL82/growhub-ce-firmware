# Growhub CE 1.2.5C — proposed candidate

This candidate combines independent per-outlet Auto/Manual ownership with an
additive native-client API and the Growhub Remote iOS app. It has not been
published as a release. This image has completed CE-to-CE OTA and a separate
native-API reboot on a physical controller.

## Behavior

- Each outlet can keep its schedule or be taken over manually. Manual takeover
  preserves the current output; returning to Auto evaluates immediately.
- The local web and MQTT clients retain their existing contracts. Schedule v3,
  existing settings/NVS, relay numbering, partitions and CE-to-CE OTA are preserved.
- `GET /api/v1/settings`, `POST /api/v1/settings`, and `GET /api/v1/status` support
  native clients. Settings reads never expose saved passwords. Writes to the new
  endpoint require the exact `X-Growhub-ID` and return JSON acknowledgements.
- Status adds sensor-validity fields. The verified sensor driver still supports
  temperature, relative humidity and light; CO2 hardware remains unsupported.
- The iOS app provides native schedules, equipment assignments, device/time,
  Wi-Fi, MQTT, firmware installation and diagnostics screens. Earlier standard CE
  firmware is read through its legacy form interface and written through `/save`.
- Controller/outlet names are saved per controller in the app, with the original
  GrowHub identity always visible. Earlier remembered-controller data migrates.
- Factory reset through the new native path is blocked if it would remove a
  disabled operation-LED override used by a known faulted controller.

## Verification and remaining gates

The firmware compiles and passes verified artifact packaging, host-side native
API snapshot tests, and real relay/schedule C tests under ASan/UBSan. The iOS app's
core tests cover native and legacy saves, identity verification, concurrent edits,
name migration, form encoding, firmware file validation and schedule preservation.
Read-only compatibility was checked on a real controller running 1.2.0C and,
after OTA, 1.2.5C. The real update preserved the controller identity, settings and
manual ownership; a separate native-API reboot preserved all 91 exported settings.
Manual outputs started OFF as designed. iPhone and
iPad simulator journeys exercise the native screens and demo settings saves.

Independent relay switching and mixed schedules are being checked by the hardware
owner. Wi-Fi/MQTT configuration changes and forced boot-failure rollback were not
exercised on the live controller. Preserve existing hardware overrides and do not
factory-reset faulted hardware for testing.

No stock NIWA cloud-to-CE OTA migration or CO2 driver is included.
