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
    // !! I would better create a service with all the needed functions instead of making an extension for the CatFact
    // Я бы лучше создал сервис со всеми необходимыми функциями вместо того, чтобы делать расширение для CatFact
    static func fetchRandomCatFact(completion: @escaping (Result<CatFact, Error>) -> Void) {
        // !! To many comments, the better practive is to try to write self-documented code instead of commenting every line of code
        // Много комментариев, поэтому лучше стараться писать самодокументированный код, а не комментировать каждую строку кода
        // Создаем URL для запроса к API "Cat Facts"
        // !! This kind of parameters is better to pass from outside so that it's possible to use different APIs in future
        // Такие параметры лучше передавать извне, чтобы в дальнейшем можно было использовать различные API.
        let apiUrl = URL(string: "https://catfact.ninja/fact")!
        
        // Создаем задачу URLSession для выполнения GET-запроса
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            // Обработка ошибок, если они возникли в процессе выполнения запроса
            // !! You have too many branches and high probablility to forget to call the completion. Instead of this in the first line you can create let result: Result<CatFact, Error>, in the last line you write completion(result). In between you put you "if|else if|else" logic. In case you forget to instantiate the result in some of the branches the compliler will let you know
            // У вас слишком много ветвей и велика вероятность забыть вызвать завершение. Вместо этого в первой строке можно создать let result: Result<CatFact, Error>, а в последней строке написать completion(result). В промежутках вы размещаете логику "if|else if|else". Если вы забудете инстанцировать результат в какой-то из ветвей, компилятор сообщит вам об этом
            // !! Watch this https://www.youtube.com/watch?v=ScMN0EyiBf4&ab_channel=AntonNazarov
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверка, что получены данные от сервера
            guard let data = data else {
                // Если данных нет, создаем ошибку "Ошибка. Отсутствуют данные" и передаем ее в замыкание completion
                // !! It's a bad practise to use NSErrors in swift code. We used them in objective-c. Now it's time to write structs or enums extending Error protocol like this: enum CatFactError: Error { case emptyData }
                // Использование NSErrors в swift-коде - плохая практика. Мы использовали их в objective-c. Теперь пришло время написать структуры или перечисления, расширяющие протокол Error, например, так: enum CatFactError: Error { case emptyData }
                completion(.failure(NSError(domain: "Ошибка. Отсутствуют данные", code: 0, userInfo: nil)))
                return
            }
            
            do {
                // Создаем JSON декодер
                // !! Don't create a decoder every request, save it in a property and reuse every time
                // Не создавайте декодер при каждом запросе, сохраните его в свойстве и используйте каждый раз заново
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

