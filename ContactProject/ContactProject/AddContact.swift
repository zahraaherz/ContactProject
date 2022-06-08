//
//  AddContact.swift
//  ContactProject
//
//  Created by Zahraa Herz on 07/06/2022.
//

import UIKit
import CoreData
import IPImage

class AddContact: UIViewController {
    

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!

    @IBOutlet weak var email: UITextField!
            
    @IBOutlet var phoneNumber: UITextField!
    
    public let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//    override func viewDidLoad(){
//        
//        image.image = UIImage(named: "Profile")
//        
//    }

//MARK: -  Action Buttons
    
    @IBAction func firstName(_ sender: Any) {
        
        if !firstName.text!.isEmpty && !lastName.text!.isEmpty || !firstName.text!.isEmpty  {
            
            let name = firstName.text! + " " + lastName.text!
            
            changeImage(name: name)
                
        } else if !firstName.text!.isEmpty && !lastName.text!.isEmpty || !lastName.text!.isEmpty {
            
            let name = lastName.text!

            changeImage(name: name)
            
        } else {
            
            image.image = UIImage(named: "Profile")
            
        }
    }
    
    
    @IBAction func lastName(_ sender: Any) {

        if firstName.text!.isEmpty && !lastName.text!.isEmpty {
            
            let name = lastName.text!
            
            changeImage(name: name)
            
        } else if !firstName.text!.isEmpty && !lastName.text!.isEmpty || !firstName.text!.isEmpty {
            
            let name = firstName.text! + " " + lastName.text!
            
            changeImage(name: name)
        } else {
            
            image.image = UIImage(named: "Profile")

        }
        
    }
    

    @IBAction func addContact(_ sender: Any){
        
        if firstName.text!.isEmpty && lastName.text!.isEmpty && email.text!.isEmpty && phoneNumber.text!.isEmpty {

            print("alert")
            
        } else {
            
            // Create a contact object
            let newContact = Contacts(context: context )
            newContact.firstName = firstName.text
            newContact.lastName = lastName.text
            newContact.email = email.text
            newContact.mobileNumber = Int64(phoneNumber.text!)!

            // Save the data
                
            do {
                try self.context.save()
            } catch {
                  let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            // go back to view controller
            self.navigationController?.popToRootViewController(animated: true)

        }
        
    }
    
    // MARK: - Other Methods

    func changeImage(name: String){
        
        let ipimage = IPImage(text: name,
                              radius: 30,
                              font: UIFont(name: "Cochin-Italic", size: 30),
                              textColor: nil,
                              randomBackgroundColor: true)
        
            image.image = ipimage.generateImage()
    }
    
    // validate first name and last name
    func isValid(testStr:String) -> Bool {
        
        guard testStr.count > 2, testStr.count < 18 else {
                        
            return false
            
        }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        
        return predicateTest.evaluate(with: testStr)
    }
    
    
}
