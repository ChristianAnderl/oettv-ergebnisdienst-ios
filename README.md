# ÖTTV Ergebnisdienst – iOS

Native SwiftUI iPhone app for quick access to the public XTTV result service.

## Included
- Start screen
- Search entry
- Ligen & Klassen
- Einzelrangliste
- Favoriten
- Last selection persistence
- Native navigation
- Live XTTV pages via WKWebView
- Direct links for table, results, ranking and match report
- No XTTV API key required for the public pages

## Build
Open the folder in Xcode on a Mac, set a unique Bundle Identifier and Apple Team, then build/archive.

For users without a Mac, the project can be built with a suitable cloud CI service and distributed through TestFlight.

Important: live XTTV page layouts are loaded from the public XTTV service; the app does not claim API access.
