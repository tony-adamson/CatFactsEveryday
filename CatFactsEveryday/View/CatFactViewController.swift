//
//  ViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import CoreData
import UIKit

class CatFactViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var catFact: UITextView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - IBAction
    @IBAction func getCatFact(_ sender: Any) {
        // Вызываем функцию для получения факта о кошках
            APIClient.getTextDataNoApiKey() { result in
            switch result {
            case .success(let catFact):
                // Обновляем текст в UITextView
                DispatchQueue.main.async {
                    self.catFact.text = catFact.fact
                }
            case .failure(let error):
                // Обработка ошибок
                self.showErrorAlert(text: "Ошибка получения факта")
                print("Ошибка при получении факта о кошках: \(error)")
            }
        }
    }
    
    @IBAction func translateFact(_ sender: Any) {
        if let text = catFact.text, !text.isEmpty {
            let textToGPT = "Переведи на русский \(text)"
            APICaller.shared.getResponse(input: textToGPT) { result in
                switch result {
                case .success(let output):
                    DispatchQueue.main.async {
                        print(output)
                        self.catFact.text = output
                    }
                case .failure:
                    self.showErrorAlert(text: "Перевод не был выполнен")
                    print("Failed")
                }
            }
        }
    }
    
    @IBAction func saveFact(_ sender: Any) {
        if let text = catFact.text, !text.isEmpty {
            let context = CoreDataStack.shared.persistentContainer.viewContext
            let newFact = CatFactsCoreData(context: context)
            newFact.factCD = text

            do {
                try context.save()
                SavedFacts.arrayOfFacts.append(newFact)
            } catch {
                showErrorAlert(text: "Ошибка при сохранении данных")
                print("Ошибка при сохранении данных: \(error)")
            }
        }
    }


    //MARK: - Other functions
    func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Ошибка!", message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

}

