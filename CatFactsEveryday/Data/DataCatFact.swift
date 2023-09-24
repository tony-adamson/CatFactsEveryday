//
//  DataCatFact.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import Foundation

struct CatFact: Codable {
    let fact: String
    let length: Int
}

extension CatFact {
    static func fetchRandomCatFact(completion: @escaping (Result<CatFact, Error>) -> Void) {
        // Создаем URL для запроса к API "Cat Facts"
        let apiUrl = URL(string: "https://catfact.ninja/fact")!
        
        // Создаем задачу URLSession для выполнения GET-запроса
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            // Обработка ошибок, если они возникли в процессе выполнения запроса
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверка, что получены данные от сервера
            guard let data = data else {
                // Если данных нет, создаем ошибку "Ошибка. Отсутствуют данные" и передаем ее в замыкание completion
                completion(.failure(NSError(domain: "Ошибка. Отсутствуют данные", code: 0, userInfo: nil)))
                return
            }
            
            do {
                // Создаем JSON декодер
                let decoder = JSONDecoder()
                
                // Декодируем полученные данные в объект типа CatFact
                let catFact = try decoder.decode(CatFact.self, from: data)
                
                // Если декодирование прошло успешно, передаем полученный объект в замыкание completion
                completion(.success(catFact))
            } catch {
                // Если произошла ошибка при декодировании JSON, передаем ошибку в замыкание completion
                completion(.failure(error))
            }
        }
        
        // Запускаем задачу URLSession для выполнения запроса
        task.resume()
    }
}

