## Nächster Schritt: Cloud-Build

Der Quellcode ist vorbereitet. Für die Installation auf dem iPhone muss daraus ein signiertes iOS-Build erstellt und über Apple TestFlight verteilt werden.

Empfohlener Ablauf:
1. Apple Developer Program aktivieren.
2. App in App Store Connect anlegen.
3. GitHub-Repository mit diesem Projekt anlegen.
4. Einen iOS-fähigen Cloud-Build (z. B. Xcode Cloud oder ein vergleichbarer CI-Dienst) verbinden.
5. Build signieren und nach App Store Connect hochladen.
6. TestFlight aktivieren und das iPhone als Tester einladen.

Apple bestätigt, dass TestFlight für Beta-Verteilung verwendet werden kann und dass das Apple Developer Program dafür erforderlich ist.
