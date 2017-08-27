//
//  TaskListViewController.swift
//  Timer
//
//  Created by Delano Kamp on 11/08/2017.
//  Copyright © 2017 Delano Kamp. All rights reserved.
//
import UIKit
import Foundation

class TaskListViewController: UIViewController, UITableViewDataSource {
    
    var items: [String] = ["Math", "Swift", "Biology"]
    
    @IBOutlet weak var listTableView: UITableView!
    @IBAction func addItem(_ sender: Any) {
        alert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "listItem") as! ItemTableViewCell
        cell.itemLabel.text = items[indexPath.row]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func alert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addTextField {
            (textfield) in
            textfield.placeholder = "Enter task name"
            
        }
        let add = UIAlertAction(title: "Add", style: .default) {
            (action) in
            let textfield = alert.textFields![0] as! UITextField
            self.items.append(textfield.text!)
            self.listTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (alert) in
            
            print("Hi")
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func startFromTasklist(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1;
    }
    
    
}
