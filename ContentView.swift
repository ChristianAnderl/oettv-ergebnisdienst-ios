import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: AppStore
    @State private var search = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Label("Suche", systemImage: "magnifyingglass")
                    }

                    NavigationLink {
                        LeagueBrowserView()
                    } label: {
                        Label("Ligen & Klassen", systemImage: "list.bullet.rectangle")
                    }

                    NavigationLink {
                        RankingView()
                    } label: {
                        Label("Einzelrangliste", systemImage: "list.number")
                    }

                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Label("Favoriten", systemImage: "star")
                    }
                }

                if let lastURL = store.lastURL, let url = URL(string: lastURL) {
                    Section("Zuletzt geöffnet") {
                        NavigationLink {
                            XTTVWebView(url: url)
                        } label: {
                            Label("XTTV-Ergebnisdienst", systemImage: "clock")
                        }
                    }
                }

                Section("Direkt zum XTTV") {
                    NavigationLink {
                        XTTVWebView(url: XTTV.resultService())
                    } label: {
                        Label("ÖTTV Ergebnisdienst öffnen", systemImage: "globe")
                    }
                }
            }
            .navigationTitle("ÖTTV Ergebnisdienst")
        }
    }
}

struct SearchView: View {
    @State private var text = ""

    var body: some View {
        List {
            Section("Spieler / Verein / Mannschaft") {
                TextField("Suchbegriff eingeben", text: $text)
                    .textInputAutocapitalization(.words)

                Text("Die öffentliche XTTV-Suche wird über den Ergebnisdienst aufgerufen. Falls für einen Begriff keine direkte Such-URL verfügbar ist, kannst du im geöffneten XTTV-Dienst suchen.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            NavigationLink {
                XTTVWebView(url: XTTV.resultService())
            } label: {
                Label("XTTV-Ergebnisdienst öffnen", systemImage: "magnifyingglass")
            }
        }
        .navigationTitle("Suche")
    }
}

struct LeagueBrowserView: View {
    var body: some View {
        List {
            Section("Auswahl") {
                Text("Verband, Saison, Bewerb und Klasse werden direkt im öffentlichen XTTV-Ergebnisdienst ausgewählt.")
                    .foregroundStyle(.secondary)
                NavigationLink {
                    XTTVWebView(url: XTTV.resultService())
                } label: {
                    Label("Ligen & Klassen auswählen", systemImage: "list.bullet")
                }
            }

            Section("Direkte Liga-Ansicht") {
                NavigationLink {
                    LeagueURLView()
                } label: {
                    Label("Liga-ID eingeben", systemImage: "number")
                }
            }
        }
        .navigationTitle("Ligen & Klassen")
    }
}

struct LeagueURLView: View {
    @State private var lid = ""

    var body: some View {
        Form {
            Section("XTTV Liga-ID") {
                TextField("z. B. 8937", text: $lid)
                    .keyboardType(.numberPad)

                if let url = XTTV.table(lid: lid), !lid.isEmpty {
                    NavigationLink("Tabelle öffnen") {
                        XTTVWebView(url: url)
                    }
                }
                if let url = XTTV.ranking(lid: lid), !lid.isEmpty {
                    NavigationLink("Einzelrangliste öffnen") {
                        XTTVWebView(url: url)
                    }
                }
                if let url = XTTV.games(lid: lid), !lid.isEmpty {
                    NavigationLink("Ergebnisse / Spiele öffnen") {
                        XTTVWebView(url: url)
                    }
                }
            }
        }
        .navigationTitle("Liga")
    }
}

struct RankingView: View {
    @State private var lid = ""

    var body: some View {
        List {
            Section("Einzelrangliste einer Klasse") {
                TextField("Liga-ID", text: $lid)
                    .keyboardType(.numberPad)

                if let url = XTTV.ranking(lid: lid), !lid.isEmpty {
                    NavigationLink {
                        XTTVWebView(url: url)
                    } label: {
                        Label("Rangliste öffnen", systemImage: "list.number")
                    }
                }
            }

            Section("ÖTTV / Ratings Central") {
                NavigationLink {
                    XTTVWebView(url: XTTV.ratingList)
                } label: {
                    Label("Ranglistenabfrage öffnen", systemImage: "chart.bar")
                }
            }
        }
        .navigationTitle("Einzelrangliste")
    }
}

struct FavoritesView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            if store.favorites.isEmpty {
                ContentUnavailableView(
                    "Keine Favoriten",
                    systemImage: "star",
                    description: Text("Favoriten können später direkt aus Liga-, Team- oder Spieleransichten ergänzt werden.")
                )
            } else {
                ForEach(store.favorites) { item in
                    if let url = URL(string: item.url) {
                        NavigationLink {
                            XTTVWebView(url: url)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text(item.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    store.favorites.remove(atOffsets: indexSet)
                }
            }
        }
        .navigationTitle("Favoriten")
    }
}
