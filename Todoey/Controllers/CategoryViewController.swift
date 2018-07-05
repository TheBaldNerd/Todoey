//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jon R on 01/07/2018.
//  Copyright © 2018 Jon R. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

//MARK:- Class variables

    //MARK: Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK:- Normal Variables
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
                
        // For Debugging and SQL Checking
        print("FILEPATH: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
    }

//MARK:- TableView Datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
        
    }
    

    
//MARK:- TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    //MARK:- Adding Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
                
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new Category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
                
    }
    
//MARK:- Data Manipulation Methods

    func saveCategories() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print("*** Error saving context (Categories): \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // This function has an internal name request: and and external name 'with'
        // It also has an optional input value - leaving blank will input Category.fetchRequest - IE ALL ARRAY
        
        do {
            
            categoryArray = try context.fetch(request)
            
        } catch {
            
            print("*** Error fetching data from context (Category): \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
