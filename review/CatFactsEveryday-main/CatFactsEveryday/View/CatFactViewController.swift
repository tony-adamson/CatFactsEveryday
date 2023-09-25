//
//  ViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

// !! ViewControllers must not even know that CoreData exists, it's not their responsibility
// ViewControllers не должны даже знать о существовании CoreData, это не входит в их обязанности
import CoreData
import UIKit

class CatFactViewController: UIViewController {

    // MARK: - Outlets
    // !! private
    @IBOutlet var catFact: UITextView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - IBAction
    @IBAction func getCatFact(_ sender: Any) {
        // Вызываем функцию для получения факта о кошках
        // !! Don't forget to use [weak self] in the closures to avoid retain cycles.
        // Не забывайте использовать [weak self] в закрытиях, чтобы избежать циклов retain.
            CatFact.fetchRandomCatFact { result in
            switch result {
            case .success(let catFact):
                // Обновляем текст в UITextView
                // !! It's better to call the completion in fetchRandomCatFact on the main thread and avoid switching to the main thread inside the ViewController.
                // Лучше вызывать завершение в fetchRandomCatFact на основном потоке и не переключаться на основной поток внутри ViewController.
                DispatchQueue.main.async {
                    self.catFact.text = catFact.fact
                }
            case .failure(let error):
                // Обработка ошибок
                // !! Use localized strings every time everywhere in the UI elements. It's very painful to localize an app when it contains not localized strings.
                // Используйте локализованные строки всегда и везде в элементах пользовательского интерфейса. Очень больно локализовать приложение, если оно содержит нелокализованные строки.
                self.showErrorAlert(text: "Ошибка получения факта")
                print("Ошибка при получении факта о кошках: \(error)")
            }
        }
    }
    
    @IBAction func translateFact(_ sender: Any) {
        // !! Use guard for such kind of checks, it saves indentations of code
        // Для такого рода проверок используйте guard, он сохраняет отступы в коде
        if let text = catFact.text, !text.isEmpty {
            // !! It's better to incapsulate this logic inside the service but not have it in a ViewController. A ViewController doesn't know about how to use chatGPT, it's stupid and controls only the view and UI.
            // Лучше инкапсулировать эту логику внутри сервиса, но не располагать ее во ViewController. ViewController не знает, как использовать chatGPT, он глуп и управляет только представлением и UI.
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
    
    // !! My preferrence is to use button action names like saveFactButtonTapped and inside you call something like catService.saveFact(), this is logical to do an action after reaction.
    // Я предпочитаю использовать имена действий кнопок, например saveFactButtonTapped, а внутри вызывать что-то вроде catService.saveFact(), это логично для выполнения действия после реакции.
    @IBAction func saveFact(_ sender: Any) {
        if let text = catFact.text, !text.isEmpty {
            // !! The ViewCotroller is the worst place where you could do this. Create a service instead with human-readable functions like "saveFact" and "getFacts".
            // ViewCotroller - худшее место, где это можно сделать. Вместо этого создайте сервис с человекопонятными функциями типа "saveFact" и "getFacts".
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CatFactsCoreData", in: context)
            let newFact = NSManagedObject(entity: entity!, insertInto: context)
            newFact.setValue(text, forKey: "factCD")

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
    // !! create an extension over UIViewController for this
    // создать для этого расширение над UIViewController
    func showErrorAlert(text: String) {
        // !! All the strings this be localized from the very beginning
        // Все строки должны быть локализованы с самого начала
        let alert = UIAlertController(title: "Ошибка!", message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

}

