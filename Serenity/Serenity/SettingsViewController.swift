//
//  SettingsViewController.swift
//  Serenity
//
//  Created by Tammy Nguyen on 5/27/24.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let logoImageView = UIImageView()
    let emailLabel = UILabel()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let savePasswordButton = UIButton()
    let pushNotificationsLabel = UILabel()
    let pushNotificationsSwitch = UISwitch()
    let datePicker = UIDatePicker()
    let repeatLabel = UILabel()
    let repeatPicker = UIPickerView()
    let saveRepeatButton = UIButton()
    let closeButton = UIButton(type: .system)
    let logoutButton = UIButton(type: .system)


    let frequencies = ["Daily", "Weekly", "Monthly"]
    var selectedFrequency = "Daily"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        pushNotificationsSwitch.addTarget(self, action: #selector(pushNotificationsSwitchChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(notificationsTimeChanged), for: .valueChanged)
        repeatPicker.delegate = self
        repeatPicker.dataSource = self
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

        // Notifications Pickers
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.isHidden = true
        view.addSubview(datePicker)
        
        saveRepeatButton.setTitle("Save", for: .normal)
        saveRepeatButton.backgroundColor = UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0)
        saveRepeatButton.layer.cornerRadius = 10
        saveRepeatButton.isHidden = true
        // Need to implement
        // saveRepeatButton.addTarget(self, action: #selector(saveRepeat), for: .touchUpInside)
        view.addSubview(saveRepeatButton)

        repeatLabel.text = "Repeat"
        repeatLabel.isHidden = true
        view.addSubview(repeatLabel)
        
        repeatPicker.isHidden = true
        view.addSubview(repeatPicker)

        // Close Button
        closeButton.setTitle("X", for: .normal)
        closeButton.addTarget(self, action: #selector(closeSettings), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Logout Button
        logoutButton.setTitle("Logout", for: .normal)
        // Need to implement
        //logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)
    }

    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        savePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        pushNotificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        pushNotificationsSwitch.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatPicker.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveRepeatButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

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
            
            repeatLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            repeatLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // Notifications Picker
            datePicker.topAnchor.constraint(equalTo: pushNotificationsLabel.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            datePicker.heightAnchor.constraint(equalToConstant: 100),
            
            repeatPicker.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 10),
            repeatPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repeatPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repeatPicker.heightAnchor.constraint(equalToConstant: 100),
            
            saveRepeatButton.topAnchor.constraint(equalTo: repeatPicker.bottomAnchor, constant: 10),
            saveRepeatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveRepeatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveRepeatButton.heightAnchor.constraint(equalToConstant: 40),

            // Close Button
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            //closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Logout Button
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func pushNotificationsSwitchChanged(_ sender: UISwitch) {
        let isOn = sender.isOn
        datePicker.isHidden = !isOn
        repeatLabel.isHidden = !isOn
        repeatPicker.isHidden = !isOn
        saveRepeatButton.isHidden = !isOn
        if !isOn {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }

    @objc private func notificationsTimeChanged(_ sender: UIDatePicker) {
        scheduleNotification(at: sender.date, frequency: selectedFrequency)
    }

    private func scheduleNotification(at date: Date, frequency: String) {
        let content = UNMutableNotificationContent()
        content.title = "Meditating Time!"
        content.body = "Remember to take some time to meditate today."
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        
        if frequency == "Weekly" {
            dateComponents.weekday = Calendar.current.component(.weekday, from: date)
        } else if frequency == "Monthly" {
            dateComponents.day = Calendar.current.component(.day, from: date)
        } else {
            dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        }
    }

    @objc private func closeSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    // Need to implement
    //    @objc private func savePassword() {
    //
    //    }
    
    // Need to implement
    //     @objc private func logout() {
    //
    //    }
    
    // Need to implement
    //     @objc private func saveRepeat() {
    //
    //    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFrequency = frequencies[row]
        if pushNotificationsSwitch.isOn {
            scheduleNotification(at: datePicker.date, frequency: selectedFrequency)
        }
    }
}
