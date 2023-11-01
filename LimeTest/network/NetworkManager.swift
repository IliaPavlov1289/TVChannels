import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

class NetworkManager {

    init(){}

    func getChannels(completion: @escaping (Result<Channels, NetworkError>) -> Void) {

        guard let url = URL(string: "http://limehd.online/playlist/channels.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let channels = try JSONDecoder().decode(Channels.self, from: data)
                completion(.success(channels))
            } catch let error {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}
