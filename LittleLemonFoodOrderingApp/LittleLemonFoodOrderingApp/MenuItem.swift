import Foundation

struct JSONMenu: Codable {
    let menu: [MenuItem]
}

struct MenuItem: Codable, Identifiable {
    var id: Int {
        return title.hashValue
    }
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String
}
