import Foundation

struct FavoriteItem: Identifiable, Codable, Hashable {
    enum Kind: String, Codable {
        case league, team, player
    }
    let id: String
    let name: String
    let detail: String
    let kind: Kind
    let url: String
}

final class AppStore: ObservableObject {
    @Published var favorites: [FavoriteItem] = [] {
        didSet { save() }
    }
    @Published var lastURL: String? {
        didSet { UserDefaults.standard.set(lastURL, forKey: "lastURL") }
    }

    private let favoritesKey = "favorites"

    init() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let value = try? JSONDecoder().decode([FavoriteItem].self, from: data) {
            favorites = value
        }
        lastURL = UserDefaults.standard.string(forKey: "lastURL")
    }

    func toggle(_ item: FavoriteItem) {
        if let idx = favorites.firstIndex(of: item) {
            favorites.remove(at: idx)
        } else {
            favorites.append(item)
        }
    }

    func isFavorite(_ item: FavoriteItem) -> Bool {
        favorites.contains(item)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}

enum XTTV {
    static let base = "https://oettv.xttv.at"

    static func resultService() -> URL {
        URL(string: "\(base)/ed/index.php")!
    }

    static func table(lid: String) -> URL? {
        URL(string: "\(base)/ed/tabelle.inc.php?lid=\(lid)")
    }

    static func ranking(lid: String) -> URL? {
        URL(string: "\(base)/ed/rangliste.inc.php?lid=\(lid)")
    }

    static func doubles(lid: String) -> URL? {
        URL(string: "\(base)/ed/doppelrangliste.inc.php?lid=\(lid)")
    }

    static func crossTable(lid: String) -> URL? {
        URL(string: "\(base)/ed/kreuztabelle.inc.php?lid=\(lid)")
    }

    static func games(lid: String) -> URL? {
        URL(string: "\(base)/ed/spiele.inc.php?lid=\(lid)")
    }

    static func matchReport(meid: String) -> URL? {
        URL(string: "\(base)/ed/spielbericht.inc.php?meid=\(meid)")
    }

    static func playerResults(pid: String) -> URL? {
        URL(string: "\(base)/ed/spielerergebnisse.inc.php?pid=\(pid)")
    }

    static let ratingList = URL(string: "\(base)/public/ranglistenabfrage.php")!
}
