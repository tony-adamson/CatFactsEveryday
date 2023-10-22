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
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let newFact = CatFactsCoreData(context: context)
        newFact.factCD = fact

        do {
            try context.save()
            SavedFacts.arrayOfFacts.append(newFact)
        } catch let error as NSError {
            print("Не удалось сохранить данные. Ошибка: \(error), \(error.userInfo)")
        }
    }
}


