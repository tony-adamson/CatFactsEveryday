//
//  SavedFactsData.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import CoreData
import UIKit

struct SavedFacts {
    // !! It's better to create a StorageDataService and not use static variables but instance properties instead.
    // Лучше создать StorageDataService и использовать не статические переменные, а свойства экземпляра.
    static var arrayOfFacts = [NSManagedObject]()
}

extension SavedFacts {
    func saveData(fact: String) {
        // 1. Получаем доступ к контексту CoreData
        // !! It's semantically incorrect that "SavedFacts" knows something about the appDelegate. The could be no appDelegate in some other app, you get a strongly coupled code when you write something like this which turns in a spaghetti code. Configure let managedContext somewhere inside the service with the parameters you pass from ourside.
        // Семантически неверно, что "SavedFacts" знает что-то о appDelegate. В другом приложении может не быть никакого appDelegate, и при написании подобного кода вы получаете сильно связанный код, который превращается в спагетти. Сконфигурируйте где-нибудь внутри сервиса managedContext с параметрами, передаваемыми с нашей стороны.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        // 2. Создаем новый объект "Fact" и устанавливаем значение атрибута "text"
        let entity = NSEntityDescription.entity(forEntityName: "CatFactsCoreData", in: managedContext)!
        let newFact = NSManagedObject(entity: entity, insertInto: managedContext)
        newFact.setValue(fact, forKey: "factCD")

        // 3. Сохраняем изменения в базе данных
        do {
            try managedContext.save()
            SavedFacts.arrayOfFacts.append(newFact) // Добавляем объект в массив для отображения
        } catch let error as NSError {
            // !! Don't cast the error to NSError. Instead of printing the error I'd better use completion block with Result(Void, Error). If it's succeeded you call completion(.success(Void())) or completion(.failure(error)) otherwise
            // Не приводите ошибку к NSError. Вместо печати ошибки лучше использовать блок завершения с Result(Void, Error). В случае успешного завершения вызывается completion(.success(Void())) или completion(.failure(error)), в противном случае
            print("Не удалось сохранить данные. Ошибка: \(error), \(error.userInfo)")
        }
    }
}

