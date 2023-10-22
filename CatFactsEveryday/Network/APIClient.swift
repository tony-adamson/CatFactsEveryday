//
//  APIClient.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 06.10.2023.
//

import UIKit
import OpenAISwift

struct APIClient {
    static let shared = APIClient()
    let decoder = JSONDecoder()
    let picDataURL = CatPicData.Contants.url
    let apiKeyForPic = CatPicData.Contants.apiKey
    let dataFactURL = DataCatFact.Contants.url
    let openAIKey = TranslateData.Constants.apiKey
    private var client: OpenAISwift?
    
    private init() {
        let config = OpenAISwift.Config(
            baseURL: "https://api.openai.com",
            endpointPrivider: OpenAIEndpointProvider(source: .openAI),
            session: .shared,
            authorizeRequest: { [self] request in
                request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
            }
        )
        self.client = OpenAISwift(config: config)
    }
    
    enum APIError: Error {
        case networkError
        case invalidURL
        case invalidData
        case decodingFailed
        case openAIRequestFailed
        case openAIEmptyResponse
    }

    // MARK: Вспомогательный метод для выполнения запроса с обработкой текста
    private func performRequestText<T: Decodable>(url: URL, apiKey: String?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.decodingFailed))
            }
        }.resume()
    }
    
    // MARK: Вспомогательный метод для выполнения запроса с изображением
    private func performRequestPicture(url: URL, apiKey: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        
        if let apiKey = apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }

    //MARK: получаем текстовые данные данные без использования ключа
    func getTextDataNoApiKey(completion: @escaping (Result<DataCatFact, Error>) -> Void) {
        if let apiUrl = URL(string: dataFactURL) {
            performRequestText(url: apiUrl, apiKey: nil, completion: completion)
        } else {
            completion(.failure(APIError.invalidURL))
        }
    }

    //MARK: получаем картинку с использованием ключа
    func getPictureWithApiKey(apiKey: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let urlString = picDataURL

        if let url = URL(string: picDataURL) {
            performRequestPicture(url: url, apiKey: apiKeyForPic) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    } else {
                        completion(.failure(APIError.decodingFailed))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(APIError.invalidURL))
        }
    }

    //MARK: получаем текстовые данные с использованием ключа
    func getDataWithApiKey(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client!.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
//                if let openAIError = error as? OpenAIError {
//                    completion(.failure(APIError.openAIRequestFailed))
//                } else {
//                    completion(.failure(error))
//                }
            }
        })
    }
}
