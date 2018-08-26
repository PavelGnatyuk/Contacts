//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Pavel Gnatyuk on 26/08/2018.
//

import UIKit

class AddContactViewController: UIViewController {

    var onSave: () -> Void = {}
    
    var firstname: String = "Name"
    var lastname: String = ""
    var phone: String = "+9721234567909"
    
    
    lazy var labelFirstName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Firstname:"
        return label
    }()

    lazy var labelLastName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lastname:"
        return label
    }()
    
    lazy var labelPhone: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Phone:"
        return label
    }()

    lazy var textFieldFirstName: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Firstname"
        return textField
    }()

    lazy var textFieldLastName: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Lastname"
        return textField
    }()

    lazy var textFieldPhone: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Phone"
        return textField
    }()

    deinit {
        print("\(#file) \(#function) \(#line)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Add new contact"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapOnSave(_:)))
        
        view.addSubview(labelFirstName)
        view.addSubview(labelLastName)
        view.addSubview(labelPhone)
        view.addSubview(textFieldFirstName)
        view.addSubview(textFieldLastName)
        view.addSubview(textFieldPhone)
        
        let guide = view.layoutMarginsGuide
        labelFirstName.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20.0).isActive = true
        labelFirstName.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        labelFirstName.widthAnchor.constraint(equalToConstant: 100.0)
        
        labelLastName.topAnchor.constraint(equalTo: labelFirstName.bottomAnchor, constant: 10.0).isActive = true
        labelLastName.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        labelLastName.widthAnchor.constraint(equalToConstant: 100.0)

        labelPhone.topAnchor.constraint(equalTo: labelLastName.bottomAnchor, constant: 10.0).isActive = true
        labelPhone.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        labelPhone.widthAnchor.constraint(equalToConstant: 100.0)

        textFieldFirstName.centerYAnchor.constraint(equalTo: labelFirstName.centerYAnchor).isActive = true
        textFieldFirstName.leadingAnchor.constraint(equalTo: labelFirstName.trailingAnchor, constant: 10.0).isActive = true
        textFieldFirstName.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 10.0).isActive = true

        textFieldLastName.centerYAnchor.constraint(equalTo: labelLastName.centerYAnchor).isActive = true
        textFieldLastName.leadingAnchor.constraint(equalTo: labelLastName.trailingAnchor).isActive = true
        textFieldLastName.leftAnchor.constraint(equalTo: textFieldFirstName.leftAnchor).isActive = true
        textFieldLastName.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 10.0).isActive = true

        textFieldPhone.centerYAnchor.constraint(equalTo: labelPhone.centerYAnchor).isActive = true
        textFieldPhone.leadingAnchor.constraint(equalTo: labelPhone.trailingAnchor).isActive = true
        textFieldPhone.leftAnchor.constraint(equalTo: textFieldFirstName.leftAnchor).isActive = true
        textFieldPhone.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 10.0).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension AddContactViewController {
    @objc func tapOnSave(_ sender: AnyObject?) {
        print("\(#file) \(#function) \(#line)")
        
        onSave()
    }
}
