//
//  SignUpViewController.swift
//  Serenity
//
//  Created by 이하은 on 5/25/24.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmTextField = UITextField()
    let nameTextField = UITextField()
    let genderTextField = UITextField()
    let signUpButton = UIButton()

    let genderPicker = UIPickerView()
    let genders = ["Male", "Female", "Non-binary", "Prefer Not to Answer"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)

        setupTextField(idTextField, placeholder: "Email")
        setupTextField(passwordTextField, placeholder: "Password", isSecure: true, content: .newPassword)
        setupTextField(passwordConfirmTextField, placeholder: "Confirm Password", isSecure: true, content: .newPassword)
        setupTextField(nameTextField, placeholder: "Present Name")
        setupTextField(genderTextField, placeholder: "Gender")
        genderTextField.delegate = self
        setupPicker()
        genderTextField.addTarget(self, action: #selector(tapGenderField), for: .touchDown)

        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = UIColor(red: 0.796, green: 0.764, blue: 0.890, alpha: 1.0)
        signUpButton.layer.cornerRadius = 5
        signUpButton.isEnabled = false
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        view.addSubview(signUpButton)

        [idTextField, passwordTextField, passwordConfirmTextField, nameTextField, genderTextField].forEach {
            $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
    }

    private func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false, content: UITextContentType? = nil) {
        textField.placeholder = placeholder
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.textContentType = content
        textField.autocapitalizationType = .none
        view.addSubview(textField)
    }

    private func setupPicker() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.inputView = genderPicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: true)
        genderTextField.inputAccessoryView = toolbar
    }

    private func setupConstraints() {
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            idTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            idTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            idTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordConfirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            passwordConfirmTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordConfirmTextField.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 40),

            nameTextField.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            genderTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            genderTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderTextField.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            genderTextField.heightAnchor.constraint(equalToConstant: 40),

            signUpButton.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func signUpAction() {
        guard let name = nameTextField.text, let email = idTextField.text, let password = passwordTextField.text, let genderPicked = genderTextField.text else {
            // Must have input has been handled
            return
        }
        let genderMapping: [String: String] = [
            "Male": "male",
            "Female": "female",
            "Non-binary": "non-binary",
            "Prefer Not to Answer": "None"
        ]
        let gender = genderMapping[genderPicked] ?? "unknown"
        NetworkManager.shared.register(name: name, email: email, password: password, gender: gender) { success in
            DispatchQueue.main.async {
                if success {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // Error messages have been handled by pop-up window
                }
            }
        }
    }

    @objc private func editingChanged(_ textField: UITextField) {
        let allFieldsFilled = !(idTextField.text?.isEmpty ?? true) &&
                              !(passwordTextField.text?.isEmpty ?? true) &&
                              !(passwordConfirmTextField.text?.isEmpty ?? true) &&
                              !(nameTextField.text?.isEmpty ?? true) &&
                              !(genderTextField.text?.isEmpty ?? true)
        signUpButton.isEnabled = allFieldsFilled
        signUpButton.backgroundColor = allFieldsFilled ? UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0) : UIColor(red: 0.796, green: 0.764, blue: 0.890, alpha: 1.0)
    }

    @objc private func tapGenderField() {
        genderTextField.becomeFirstResponder()
    }

    @objc private func dismissPicker() {
        view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        dismissPicker()
        editingChanged(genderTextField)
    }
}
