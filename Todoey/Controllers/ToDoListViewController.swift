//
//  ViewController.swift
//  Todoey
//
//  Created by Jon R on 29/06/2018.
//  Copyright © 2018 Jon R. All rights reserved.
//

import UIKit
import CoreData



class ToDoListViewController: UITableViewController {
    
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
////////////////////////
//MARK:- Class variables
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet {
            
            loadItems()
            
        }
    }
    
//////////////////////
//MARK:- Start of main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
/////////////////////////////////////
//MARK:- Tableview Datasourve Methods
    
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
////////////////////////
//MARK:- - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen once the user clicks the add item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Crete new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
//MARK:- Model Manipulation Methods
        
    func saveItems() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print("*** Error saving context: \(error)")
            
        }
        
        self.tableView.reloadData()
        
        }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // This function has an internal name request: and and external name 'with'
        // It also has an optional input value - leaving blank will input Item.fetchRequest - IE ALL ARRAY

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
            
        }
        
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate

        do {
            
            itemArray = try context.fetch(request)
            
        } catch {
            
            print("*** Error fetching data from context: \(error)")
            
        }
        
        tableView.reloadData()
    }

}

//MARK:- Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Searching 'title' entity thats CONTAINS the searchBar.text
        // the [cd] means, no CASE and no DIACRITIC - IE é or å
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar,
      textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
    
    
    
    
    
    
    
}


