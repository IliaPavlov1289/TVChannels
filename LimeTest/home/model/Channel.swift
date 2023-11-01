import Foundation

struct Channels: Codable {
    let channels: [Channel]
}

struct Channel: Codable {
    let id: Int
    let name: String
    let image: String
    let current: Current
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name_ru"
        case image
        case current
    }
}

struct Current: Codable {
    let title: String
    let desc: String
}
