//
//  CatPicData.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import UIKit

struct CatPicData: Codable {
    let url: String
}

class CatPicAPI {
    static let shared = CatPicAPI()
    
    private let apiKey = "live_T8hJZQtkwYUQ2zMUcjIJKHLAwQcIZ3bPSTyGi2lonHWgotHoUJR5o3vBHZJx3E48-" 
    
    private init() {}
    
    func getCatPicture(completion: @escaping (Result<UIImage, Error>) -> Void) {
        let urlString = "https://api.thecatapi.com/v1/images/search"
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "1")]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let catPicData = try JSONDecoder().decode([CatPicData].self, from: data)
                if let firstPicUrlString = catPicData.first?.url,
                   let picUrl = URL(string: firstPicUrlString),
                   let picData = try? Data(contentsOf: picUrl),
                   let image = UIImage(data: picData) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "Invalid image data", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

