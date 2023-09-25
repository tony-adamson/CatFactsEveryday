//
//  ChosenFactsTableViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

// !! ViewControllers must not even know that CoreData exists, it's not their responsibility
// ViewControllers не должны даже знать о существовании CoreData, это не входит в их обязанности
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
            // !! You fetch all the data every time a user switches to the "Favourite" tab. Imagine you have a million of facts, it could be very slow. Use a service which would hold the arrayOfFacts, don't hold the in the ViewController
            // Вы получаете все данные каждый раз, когда пользователь переходит на вкладку "Избранное". Представьте, что у вас миллион фактов, это может быть очень медленно. Используйте сервис, который будет хранить массив фактов (arrayOfFacts), не храните его в ViewController
            arrayOfFacts = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            showErrorAlert(text: "Could not fetch")
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    // MARK: - Table view data source

    // !! create a separate extension for table delegates and datasources
    // создать отдельное расширение для делегатов таблиц и источников данных
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // !! You should register this identifier first for the table view
        // Сначала необходимо зарегистрировать этот идентификатор для табличного представления
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath)

        // Получаем текст факта из массива arrayOfFacts для текущей строки
        let factText = arrayOfFacts[indexPath.row]
        
        // Устанавливаем текст факта в текстовое поле ячейки
        // !! Normally you should extend NSManageObject with your own data type and get the needed values as properties but not by value(forKey:)
        // Обычно следует расширить NSManageObject собственным типом данных и получать нужные значения как свойства, но не по value(forKey:)
        cell.textLabel?.text = factText.value(forKey: "factCD") as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаление объекта из CoreData
            // !! This is not what a ViewController should do. Do it somewhere else, here you only handle the result of saving/deleting
            // Это не то, что должен делать ViewController. Делайте это в другом месте, здесь вы обрабатываете только результат сохранения/удаления
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
