//
//  ViewController.swift
//  Todoey
//
//  Created by Jon R on 29/06/2018.
//  Copyright © 2018 Jon R. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
////////////////////////
//MARK:- Class variables
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
//////////////////////
//MARK:- Start of main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

    }
    
    /////////////////////////////////////
    //MARK:- Tableview Datasourve Merhods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        // Turnery operator
        // If item.done is true, then add checkmark - if not, no checkmark
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
///////////////////////////////////
//MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
////////////////////////
//MARK:- - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Set a texfield object for UIAlert
        var textField = UITextField()
        
        // Set parameters for UIAlert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // Set button type for UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen once the user clicks the add item button on our UIAlert
            
            // Initialise new item
            let newItem = Item()
            
            // Set the new item from textfield
            newItem.title = textField.text!
            
            // Add new item to array
            self.itemArray.append(newItem)
            
            // SAVE
            self.saveItems()
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Crete new item"
            textField = alertTextField
            
            }
        }
        
        // Show UIAlert popup
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
//MARK:- Model Manipulation Methods
        
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            
            print("Error encoding item array, \(error)")
            
        }
        
        self.tableView.reloadData()
        
        
    }
    
    func loadItems() {

        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                
                print("Error in decoding file: \(error)")
                
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

