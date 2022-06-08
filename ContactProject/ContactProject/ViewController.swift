//
//  ViewController.swift
//  ContactProject
//
//  Created by Zahraa Herz on 06/06/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController  {
    
    //Mark: Properties
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contacts: [Contacts]?
    
    //Mark: View Life cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        fetchContacts()

    }

    
    // MARK: - Other Methods
    
    func fetchContacts(){
        
        do {
            self.contacts = try context.fetch(Contacts.fetchRequest())

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        } catch {

        }
    }

}

// MARK: - Table view data source

extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contacts?.count ?? 0
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = contacts![indexPath.row]
        
        cell.textLabel?.text = name.firstName! + " " + name.lastName!
        
        return cell
    }
    
}
