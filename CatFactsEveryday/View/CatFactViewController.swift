//
//  ViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import UIKit

class CatFactViewController: UIViewController {

    @IBOutlet var catFact: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getCatFact(_ sender: Any) {
        // Вызываем функцию для получения факта о кошках
            CatFact.fetchRandomCatFact { result in
            switch result {
            case .success(let catFact):
                // Обновляем текст в UITextView
                DispatchQueue.main.async {
                    self.catFact.text = catFact.fact
                }
            case .failure(let error):
                // Обработка ошибок
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
                    print("Failed")
                }
            }
        }
    }
    
    @IBAction func saveFact(_ sender: Any) {
        if let text = catFact.text, !text.isEmpty {
            SavedFacts.arrayOfFacts.append(text)
        }
    }

    
}

