//
//  TranslateData.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import OpenAISwift
import Foundation

final class APICaller {
    static let shared = APICaller()
    
    @frozen enum Constants {
        static let key = "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-" //- api key -
    }
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        let config = OpenAISwift.Config(
            baseURL: "https://api.openai.com",
            endpointPrivider: OpenAIEndpointProvider(source: .openAI),
            session: .shared,
            authorizeRequest: { request in
                request.setValue("Bearer \(Constants.key)", forHTTPHeaderField: "Authorization")
            }
        )
        
        self.client = OpenAISwift(config: config)
    }
    
    public func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let model):
                print(model)
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        })
    }
}
