//
//  ViewController.swift
//  ToDoList
//
//  Created by Jeff Barra on 12/20/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    // create instance of UITableView
    private let table: UITableView = {
        let table = UITableView()
        // method call on the "table" instance
        table.register(UITableViewCell.self,
        // string that identifies a cell that can be reused by the table view ("cell")
        forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    var items = [String]()
    
    // to be run on page load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "To Do List"
        view.addSubview(table)
        table.dataSource = self
        table.separatorStyle = .none
        

    
        // plus button to add to do list item (.add = "+", #selector(objc method)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    // objc method - alert method for the button press
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter a new to do list item", preferredStyle: .alert)
        
        // text field with placeholder
        alert.addTextField { field in field.placeholder = "Enter item..."}
        
        // buttons
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            // checks for text field and not empty
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    
                    // enter new to do list item
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }

    
    // adjust the frame of a table view (table) to match the bounds of the view. This is a common practice to ensure that the table view takes up the entire available space within its parent view.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    // define the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // this line dequeues a reusable cell from the table view's reuse pool using the identifier "cell" and the specified index path. If a reusable cell is not available, a new one is created.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // This line sets the text of the cell's textLabel to the string value from the items array at the corresponding row index.
        cell.textLabel?.text = items[indexPath.row]

        // create a UIView for selected cell background color
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .none
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }

}

