//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Pavel Gnatyuk on 26/08/2018.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController {

    let viewContext: NSManagedObjectContext
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var dataController: NSFetchedResultsController<Person> = {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "firstname", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        view.backgroundColor = .white

        do {
            try dataController.performFetch()
        } catch let error {
            print("Data loading error: \(error.localizedDescription)")
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapOnAdd(_:)))
        
        view.addSubview(tableView)
        let guide = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let persons = dataController.fetchedObjects else {
            return 0
        }
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "PersonCell")
        }
        let obj = dataController.object(at: indexPath)
        cell?.textLabel?.text = obj.firstname ?? "No name"
        cell?.detailTextLabel?.text = obj.phone ?? "No phone number"
        cell?.accessoryType = .detailDisclosureButton
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let obj = dataController.object(at: indexPath)
            viewContext.delete(obj)
            do {
                try viewContext.save()
            }
            catch let error {
                print("Failed to delete data. Error: \(error)")
            }
        }
    }
}

extension ContactsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .fade)
            }
            
        case .update:
            if let index = newIndexPath {
                let cell = tableView.cellForRow(at: index)
                let obj = dataController.object(at: index)
                cell?.textLabel?.text = obj.firstname ?? "No name"
            }
            
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .fade)
            }
            
        case .move:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .fade)
            }
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .fade)
            }
        }
    }
}

extension ContactsViewController {
    @objc func tapOnAdd(_ sender: AnyObject?) {
        print("\(#file) \(#function) \(#line)")
        
        let controller = AddContactViewController()
        weak var add = controller
        controller.onSave = { [weak self, weak add] in

            if let `self` = self, let `controller` = add {
                let person = Person(context: self.viewContext)
                person.firstname = controller.firstname
                person.lastname = controller.lastname
                person.phone = controller.phone
                
                do {
                    try self.viewContext.save()
                    
                } catch let error {
                    
                    print("Failed to save new person. Error: \(error)")
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
