//
//  ChosenFactsTableViewController.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 24.09.2023.
//

import UIKit

class ChosenFactsTableViewController: UITableViewController {

    var arrayOfFacts = [String]()
    
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


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfFacts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath)

        // Получаем текст факта из массива arrayOfFacts для текущей строки
        let factText = arrayOfFacts[indexPath.row]
        
        // Устанавливаем текст факта в текстовое поле ячейки
        cell.textLabel?.text = factText

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
