//
//  SavedFactsData.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import CoreData
import UIKit

struct SavedFacts {
    static var arrayOfFacts = [NSManagedObject]()
}

extension SavedFacts {
    func saveData(fact: String) {
        // 1. Получаем доступ к контексту CoreData
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
            print("Не удалось сохранить данные. Ошибка: \(error), \(error.userInfo)")
        }
    }
}

