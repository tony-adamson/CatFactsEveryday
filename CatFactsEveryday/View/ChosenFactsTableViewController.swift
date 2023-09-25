//
//  ChosenFactsTableViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import CoreData
import UIKit

class ChosenFactsTableViewController: UITableViewController {

    var arrayOfFacts = [NSManagedObject]()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        arrayOfFacts = SavedFacts.arrayOfFacts

        // Конфигурируем заголовок
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.textLabel?.text = "Избранные факты"
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 20) // Жирный текст и размер шрифта
        headerView.textLabel?.textColor = UIColor.black // Цвет текста
        headerView.textLabel?.textAlignment = .left // Выравнивание текста

        tableView.tableHeaderView = headerView
    }
    
    // Подгружаем пользовательские данные из СoreData 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CatFactsCoreData")

        do {
            arrayOfFacts = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            showErrorAlert(text: "Could not fetch")
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath)

        // Получаем текст факта из массива arrayOfFacts для текущей строки
        let factText = arrayOfFacts[indexPath.row]
        
        // Устанавливаем текст факта в текстовое поле ячейки
        cell.textLabel?.text = factText.value(forKey: "factCD") as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаление объекта из CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(arrayOfFacts[indexPath.row] )
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                showErrorAlert(text: "Ошибка сохранения")
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            // Удаление объекта из массива данных
            arrayOfFacts.remove(at: indexPath.row)
            
            // Обновление отображения таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
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
