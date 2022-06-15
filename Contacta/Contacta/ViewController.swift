//
//  ViewController.swift
//  Contacta
//
//  Created by Zahraa Herz on 09/06/2022.
//

import UIKit

class ViewController: UIViewController {

    //Mark: Properties
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contacts: [Contacts]?
    
    var selectedData: Contacts?
    
    var filteredData: [Contacts]!
    
    var isFiltered = false

    //Mark: View Life cycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchContacts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

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
            let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// MARK: - Search bar data source

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isFiltered = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.count == 0{
            
            isFiltered = false
            
        } else {
            
            isFiltered = true
            filteredData = searchText.isEmpty ? contacts : contacts!.filter({
                (dataString: Contacts) -> Bool in
                return (((dataString.firstName! + " " + dataString.lastName!).range(of: searchText,options: .caseInsensitive) != nil) )
            })
        }
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isFiltered {
            
            return self.contacts?.count ?? 0
            
        } else {
            
            return filteredData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = isFiltered ? filteredData![indexPath.row] : contacts![indexPath.row]
                
        cell.textLabel?.text = name.firstName! + " " + name.lastName!
                
        return cell
    }
    
}

// MARK: - Protocol

extension ViewController:  EditContacts {
    
    func update(contact: Contacts?) {
        
        if let row = self.contacts?.firstIndex(where: { $0.phoneNumber == contact?.phoneNumber}){
            contacts![row] = contact!
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "contactDetails" {
            
                let secondViewController = segue.destination as! ContactsDetailsViewController
                if let cell = sender as? UITableViewCell,
                   let indexPath = self.tableView.indexPath(for: cell) {
                    secondViewController.delegate = self
                    secondViewController.contact = contacts![indexPath.row]
                }
        }
    }
}
