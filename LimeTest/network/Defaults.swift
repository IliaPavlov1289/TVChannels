import Foundation

struct Defaults {

    struct favourites {
        private static let key = "favourites"

        static var value: [Channel]? {
            get {
                guard let data = UserDefaults.standard.data(forKey: self.key) else {
                    return []
                }
                return  try? JSONDecoder().decode([Channel].self, from: data)
            }
            set {
                let encoded = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey: self.key)
            }
        }
    }
}
