//
//  AddContact.swift
//  Contacta
//
//  Created by Zahraa Herz on 09/06/2022.
//

import UIKit

class AddContact: UIViewController {

    //Mark: Properties

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var firstName: UITextField!
    
    @IBOutlet var lastName: UITextField!
        
    @IBOutlet var phoneNumber: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var validateFirstName: UILabel!
    
    @IBOutlet var validateLastName: UILabel!
    
    @IBOutlet var validateEmail: UILabel!
    
    @IBOutlet var validatePhone: UILabel!
    
    @IBOutlet var addButton: UIButton!
    
    var isFirstNameValid = false
    
    var isLastNameValid = false
    
    var isEmailValid = false
    
    var isPhoneValid = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var lastNameStr = ""
    
    var firstNameStr = ""


    //MARK: -  Action Buttons
    
    @IBAction func firstNameChanged(_ sender: Any) {
        
        // Validation
        let firstNameString = firstName.text ?? ""
        
        if validateString(string: firstNameString){
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
            
            validateFirstName.attributedText = NSAttributedString(string: "Valid", attributes: attributes)
            
            isFirstNameValid = true
                                
        } else {
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
            
            validateFirstName.attributedText = NSAttributedString(string: "Invalid", attributes: attributes)
            
            isFirstNameValid = false
        }
        
        // Image Chenged
        changeImage()
        
    }
    
    @IBAction func lastNameChanged(_ sender: Any) {
        
        // Validation
        let lastNameString = lastName.text ?? ""
        
        if validateString(string: lastNameString){
            
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
    
    
    @IBAction func phoneChanged(_ sender: Any) {
        
        let phone = phoneNumber.text ?? ""
        
        validatePhoneNumber(phone)
    }
    
    
    @IBAction func emailChanged(_ sender: Any) {
        
        let email = email.text ?? "" 
        
        validateEmail(email: email)
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if isLastNameValid && isFirstNameValid && isEmailValid && isPhoneValid {
            
            // Create a contact object
            let newContact = Contacts(context: context )
            newContact.firstName = firstName.text
            newContact.lastName = lastName.text
            newContact.email = email.text
            newContact.phoneNumber = phoneNumber.text

            // Save the data
            do {
                try self.context.save()
            } catch {
                  let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            // Go back to view controller
            self.navigationController?.popViewController(animated: true)

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
    
    //MARK: -  Other Methods
    
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
    
    func validateString(string: String) -> Bool {
        
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]{3,22}")
                
        if predicateTest.evaluate(with: string) {
                
            return true
                
        } else {
            
            return false
            
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

    
    func changeImage(){
                
        if lastName.text!.isEmpty && firstName.text!.isEmpty {
            
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
}
