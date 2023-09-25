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
        // Создаем контекст CoreData из shared CoreDataStack
        let context = CoreDataStack.shared.persistentContainer.viewContext

        // Создаем новый объект "CatFactsCoreData" и устанавливаем значение атрибута "factCD"
        let newFact = CatFactsCoreData(context: context)
        newFact.factCD = fact

        // Сохраняем изменения в контексте CoreData
        do {
            try context.save()
            SavedFacts.arrayOfFacts.append(newFact) // Добавляем объект в массив для отображения
        } catch let error as NSError {
            print("Не удалось сохранить данные. Ошибка: \(error), \(error.userInfo)")
        }
    }
}


