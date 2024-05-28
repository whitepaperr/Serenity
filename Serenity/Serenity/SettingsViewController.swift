//
//  SettingsViewController.swift
//  Serenity
//
//  Created by Tammy Nguyen on 5/27/24.
//

import UIKit

class SettingsViewController: UIViewController {

    let logoImageView = UIImageView()
    let emailLabel = UILabel()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let savePasswordButton = UIButton()
    let pushNotificationsLabel = UILabel()
    let pushNotificationsSwitch = UISwitch()
    let closeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        title = "Settings"

        // Logo
        logoImageView.image = UIImage(named: "Serenity")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        // Email
        emailLabel.text = "Email"
        // Pull from user database?
        view.addSubview(emailLabel)

        // Password Change
        passwordLabel.text = "Change Password"
        view.addSubview(passwordLabel)
        
        passwordTextField.placeholder = "Enter new password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        view.addSubview(passwordTextField)

        savePasswordButton.setTitle("Save", for: .normal)
        savePasswordButton.backgroundColor = UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0)
        savePasswordButton.layer.cornerRadius = 10
        // Need to implement
        //savePasswordButton.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
        view.addSubview(savePasswordButton)

        // Push Notifications Switch
        pushNotificationsLabel.text = "Push Notifications"
        view.addSubview(pushNotificationsLabel)

        view.addSubview(pushNotificationsSwitch)

        // Close Button
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeSettings), for: .touchUpInside)
        view.addSubview(closeButton)
    }

    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        savePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        pushNotificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        pushNotificationsSwitch.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),

            // Email
            emailLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Password Change
            passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            savePasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            savePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            savePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            savePasswordButton.heightAnchor.constraint(equalToConstant: 40),

            // Push Notifications
            pushNotificationsLabel.topAnchor.constraint(equalTo: savePasswordButton.bottomAnchor, constant: 20),
            pushNotificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            pushNotificationsSwitch.centerYAnchor.constraint(equalTo: pushNotificationsLabel.centerYAnchor),
            pushNotificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Close Button
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func closeSettings() {
        dismiss(animated: true, completion: nil)
    }
    
// Need to implement
//    @objc private func savePassword() {
//
//    }
}

