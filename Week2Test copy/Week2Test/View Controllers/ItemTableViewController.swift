//
//  ListTableViewController.swift
//  Week2Test
//
//  Created by Jackson Tubbs on 8/9/19.
//  Copyright © 2019 Jax Tubbs. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ItemController.shared.fetchedResultsController.delegate = self
    }
    // MARK: - Actions
    
    // Creates a new item
    @IBAction func newItemTapped(_ sender: Any) {
        // Creates a alert controller, the base of the alert
        let alert = UIAlertController(title: "New Item", message: "Enter Name", preferredStyle: .alert)
        // Adds text field for entering Item name
        alert.addTextField { (textField) in
        }
        // Adds action to the alert for adding a new item
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            // Handles the creation of a new item when pressed
            guard let newItemName = alert.textFields?[0].text else {return}
            ItemController.shared.createItem(name: newItemName)
        }))
        // creates a cancel option that will just dismiss the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ItemController.shared.fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(ItemController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? -4)")
        return ItemController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ButtonTableViewCell else {return UITableViewCell()}
        let item = ItemController.shared.fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        cell.update(item: item)
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ItemController.shared.fetchedResultsController.object(at: indexPath)
            ItemController.shared.deleteItem(item: item)
        }
    }
} // End of class

// Conforming to the ItemTableViewCellDelegate Protocol created in the custom table view cell
extension ItemTableViewController: ItemTableViewCellDelegate {
    func itemButtonTapped(_ sender: ButtonTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else {return}
        let item = ItemController.shared.fetchedResultsController.object(at: index)
        ItemController.shared.toggleComplete(item: item)
        sender.update(item: item)
    }
}

// Nice fancy code that will control the reloading of data and inserting/moving/deleting of rows
extension ItemTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: return
        }
    }
}
