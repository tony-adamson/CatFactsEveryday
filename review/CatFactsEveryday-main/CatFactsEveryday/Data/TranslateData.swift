//
//  TranslateData.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import OpenAISwift
import Foundation

final class APICaller {
    // !! I would avoid to use singletons for such kind of entities. It's difficult to test them and to mock them. There can be requirement to have two or more instances of APICaller in future and it's impossible to do this with singletons
    // Я бы не стал использовать синглтоны для такого рода сущностей. Их трудно тестировать и издеваться над ними. В будущем может возникнуть потребность иметь два или более экземпляров APICaller, а с одиночными экземплярами это сделать невозможно.
    static let shared = APICaller()
    
    // !! It's probably should private if it's here but better pass the key in init so that it's possible to pass some other key while instantiating the class
    // Вероятно, он должен быть приватным, если он здесь, но лучше передать ключ в init, чтобы можно было передать другой ключ при инстанцировании класса
    @frozen enum Constants {
        static let key = "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-" //- api key -
    }
    
    // !! You could setup it in init and not make it optional
    // Вы можете настроить его в init и не делать его опциональным
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        let config = OpenAISwift.Config(
            // !! I would recommend to pass the URL from outside so that it's possible to replace the endpoint with some stage one for test purposes
            // я бы рекомендовал передавать URL извне, чтобы можно было заменить конечную точку на какую-нибудь стадию для тестирования
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
                // !! It's better to use swift Logger or some library like SwiftyBeaver instead of print. print is synchronous and slow and it can reveal privacy sensitive data in device console if you print something like username and password.
                // Вместо print лучше использовать swift Logger или какую-либо библиотеку типа SwiftyBeaver. print синхронна и медленна, а также может вывести конфиденциальные данные в консоль устройства, если вы печатаете что-то вроде имени пользователя и пароля.
                print(model)
                // !! In case of empty choices you could call e.g. completion(.failure(APICaller.emptyResponse)). For this you could create a enum APICallerError: Error { case emptyResponse }
                // В случае пустых вариантов можно вызвать, например, completion(.failure(APICaller.emptyResponse)). Для этого можно создать перечисление APICallerError: Error { case emptyResponse }
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        })
    }
}
