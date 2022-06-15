//
//  ContactsDetailsViewController.swift
//  Contacta
//
//  Created by Zahraa Herz on 12/06/2022.
//

import UIKit
import CoreData

protocol EditContacts{
    
    func update(contact: Contacts?)
    
}

class ContactsDetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var firstName: UITextField!

    @IBOutlet var validateFirstName: UILabel!

    @IBOutlet var lastName: UITextField!

    @IBOutlet var validateLastName: UILabel!

    @IBOutlet var email: UITextField!

    @IBOutlet var validateEmail: UILabel!

    @IBOutlet var phone: UITextField!

    @IBOutlet var validatePhone: UILabel!

    @IBOutlet var editButton: UIButton!

    @IBOutlet var cancel: UIButton!

    @IBOutlet var save: UIButton!

    @IBOutlet var contactName: UILabel!

    var delegate : EditContacts?

    var contact : Contacts?

    var lastNameStr = ""

    var firstNameStr = ""

    let callFunc = AddContact()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var isFirstNameValid = true

    var isLastNameValid = true

    var isEmailValid = true

    var isPhoneValid = true

    //Mark: View Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        contactName.text = (contact?.firstName?.uppercased())! + " " + (contact?.lastName?.uppercased())!

        disableText()

        changeImage()
    }

    //MARK: -  Action Buttons

    @IBAction func removeContact(_ sender: Any) {

        // Create Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

            //Person to remove
            let personToRemove = self.contact!.self

            //Remove the person
            self.context.delete(personToRemove)

            //Save the data
            do {
                try self.context.save()
            } catch {
                  let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }

            // Go back to view controller
            self.navigationController?.popViewController(animated: true)

        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)

    }

    @IBAction func changeFirstName(_ sender: Any){

        let firstNameString = firstName.text ?? ""

        if callFunc.validateString(string: firstNameString){

            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green]

            validateFirstName.attributedText = NSAttributedString(string: "Valid", attributes: attributes)

            isFirstNameValid = true

        } else {

            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

            validateFirstName.attributedText = NSAttributedString(string: "Invalid", attributes: attributes)

            isFirstNameValid = false
        }

        changeImage()
    }

    @IBAction func changeLastName(_ sender: Any){
        
        // Validation
        let lastNameString = lastName.text ?? ""
        
        if callFunc.validateString(string: lastNameString){
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
            
            validateLastName.attributedText = NSAttributedString(string: "Valid", attributes: attributes)
            
            isLastNameValid = true
            
        } else {
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
            
            validateLastName.attributedText = NSAttributedString(string: "Invalid", attributes: attributes)
            
            isLastNameValid = false
        }
        
        // Image Chenged
        changeImage()
    }
    
    @IBAction func changeEmail(_ sender: Any) {

        let email = email.text ?? ""

        validateEmail(email: email)
    }

    @IBAction func changePhone(_ sender: Any) {
        
        let phone = phone.text ?? ""
        
        validatePhoneNumber(phone)
    }

    @IBAction func editButton(_ sender: Any){

        enableText()
    }

    @IBAction func save(_ sender: Any) {
        
        if self.isEmailValid && self.isPhoneValid && self.isLastNameValid && self.isFirstNameValid {

        // Create Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to save this?", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK",
                               style: .default,
                               handler: { (action) -> Void in
                
                                    // Change the contact
                                    self.contact?.email = self.email.text
                                    self.contact?.firstName = self.firstName.text
                                    self.contact?.lastName = self.lastName.text
                                    self.contact?.phoneNumber = self.phone.text
                                        
                                    // Save the data
                                    do {
                                        try self.context.save()
                                    } catch {
                                            let nserror = error as NSError
                                            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                                    }

                                    // Go back to view controller
                                    self.navigationController?.popViewController(animated: true)

                                })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
            print("Cancel button tapped")
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
        } else {
            
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Error", message: "Make sure that every field is valid and not empty", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

    @IBAction func cancel(_ sender: Any) {

        // Create Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel this?", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.disableText()
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        self.present(dialogMessage, animated: true, completion: nil)
    }

// MARK: - Other Methods

    func disableText(){

        email.isEnabled = false
        firstName.isEnabled = false
        lastName.isEnabled = false
        phone.isEnabled = false

        editButton.isHidden = false
        cancel.isHidden = true
        save.isHidden = true

        validateFirstName.isHidden = true
        validateLastName.isHidden = true
        validateEmail.isHidden = true
        validatePhone.isHidden = true

        email.text = contact?.email
        firstName.text = contact?.firstName
        lastName.text = contact?.lastName
        phone.text = contact?.phoneNumber

    }

    func enableText(){

        email.isEnabled = true
        firstName.isEnabled = true
        lastName.isEnabled = true
        phone.isEnabled = true

        editButton.isHidden = true
        cancel.isHidden = false
        save.isHidden = false

        validateFirstName.isHidden = false
        validateLastName.isHidden = false
        validateEmail.isHidden = false
        validatePhone.isHidden = false

        email.text = contact?.email
        firstName.text = contact?.firstName
        lastName.text = contact?.lastName
        phone.text = contact?.phoneNumber

    }

    func changeImage(){

        if (contact?.lastName?.isEmpty)! && (contact?.firstName?.isEmpty)! ||
            lastName.text!.isEmpty && firstName.text!.isEmpty {

            imageView.image = UIImage(named: "Profile")

        } else {

            // Cheking if the last name is empty or not
            if !lastName.text!.isEmpty  {

                lastNameStr =  String(lastName.text!.first!)

            } else {

                lastNameStr = ""
            }

            // Cheking if the first name is empty or not
            if !firstName.text!.isEmpty {

                firstNameStr = String(firstName.text!.first!)

            }else {

                firstNameStr = ""
            }
            
            // change the Name
            contactName.text = firstName.text!.uppercased() + " " + lastName.text!.uppercased()
            
            // Create a label to view the first letter of the user first name and last name
            let imageLabel = UILabel()
            imageLabel.frame.size = CGSize(width: 100.0, height: 100.0)
            imageLabel.textColor = UIColor.white
            imageLabel.text = firstNameStr.uppercased() + lastNameStr.uppercased()
            imageLabel.font = imageLabel.font.withSize(30)
            imageLabel.textAlignment = NSTextAlignment.center
            imageLabel.backgroundColor = UIColor.blue
            imageLabel.layer.masksToBounds = true
            imageLabel.layer.cornerRadius = 50.0

            UIGraphicsBeginImageContext(imageLabel.frame.size)
            imageLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

        }
    }
    
    func validateEmail(email: String) {
        
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        
        if predicate.evaluate(with: email){
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green]

            validateEmail.attributedText = NSAttributedString(string: "Valid Email", attributes: attributes)
            
            isEmailValid = true
            
        } else {
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

            validateEmail.attributedText = NSAttributedString(string: "Invalid Email", attributes: attributes)
            
            isEmailValid = false
        }
    }

    func validatePhoneNumber(_ value: String){
        
        let set = CharacterSet(charactersIn: value)
        
        if !CharacterSet.decimalDigits.isSuperset(of: set) {
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

            validatePhone.attributedText = NSAttributedString(string: "Phone number should contain only digit", attributes: attributes)
            
            isPhoneValid = false
            
        } else if value.count != 8 {
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

            validatePhone.attributedText = NSAttributedString(string: "Phone number sould be 8 digits", attributes: attributes)
            
            isPhoneValid = false
            
        } else {
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green]

            validatePhone.attributedText = NSAttributedString(string: "Valid number ", attributes: attributes)
            
            isPhoneValid = true
            
        }
    }
}
