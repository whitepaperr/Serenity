import UIKit
import UserNotifications

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let logoImageView = UIImageView()
    let emailLabel = UILabel()
    let emailInfoLabel = UILabel()
    let nameLabel = UILabel()
    let nameInfoLabel = UILabel()
    let genderLabel = UILabel()
    let genderInfoLabel = UILabel()
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
    
    private let pushNotificationsEnabledKey = "pushNotificationsEnabled"
    private let notificationTimeKey = "notificationTime"
    private let repeatFrequencyKey = "repeatFrequency"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        pushNotificationsSwitch.addTarget(self, action: #selector(pushNotificationsSwitchChanged), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(notificationsTimeChanged), for: .valueChanged)
        repeatPicker.delegate = self
        repeatPicker.dataSource = self
        restoreSettings()
        fetchUserInfo()
        setupSwipeBackGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        
        // Logo
        logoImageView.image = UIImage(named: "Serenity")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        // Email
        emailLabel.text = "Email:"
        view.addSubview(emailLabel)
        emailInfoLabel.text = ""
        view.addSubview(emailInfoLabel)
        
        // Name
        nameLabel.text = "Name:"
        view.addSubview(nameLabel)
        nameInfoLabel.text = ""
        view.addSubview(nameInfoLabel)
        
        // Gender
        genderLabel.text = "Gender:"
        view.addSubview(genderLabel)
        genderInfoLabel.text = ""
        view.addSubview(genderInfoLabel)
        
        // Password Change
        passwordLabel.text = "Change Password:"
        view.addSubview(passwordLabel)
        
        passwordTextField.placeholder = "Enter new password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        view.addSubview(passwordTextField)
        
        savePasswordButton.setTitle("Save", for: .normal)
        savePasswordButton.backgroundColor = UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0)
        savePasswordButton.layer.cornerRadius = 10
        savePasswordButton.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
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
        
        saveRepeatButton.addTarget(self, action: #selector(saveRepeat), for: .touchUpInside)
        view.addSubview(saveRepeatButton)
        
        repeatLabel.text = "Repeat"
        repeatLabel.isHidden = true
        view.addSubview(repeatLabel)
        
        repeatPicker.isHidden = true
        view.addSubview(repeatPicker)
        
        // Close Button
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeSettings), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Logout Button
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderInfoLabel.translatesAutoresizingMaskIntoConstraints = false
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
            emailInfoLabel.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 10),
            emailInfoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: emailInfoLabel.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameInfoLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameInfoLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Gender
            genderLabel.topAnchor.constraint(equalTo: nameInfoLabel.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderInfoLabel.topAnchor.constraint(equalTo: genderLabel.topAnchor),
            genderInfoLabel.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 10),
            genderInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Password Change
            passwordLabel.topAnchor.constraint(equalTo: genderInfoLabel.bottomAnchor, constant: 20),
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
            datePicker.heightAnchor.constraint(equalToConstant: 75),
            
            repeatPicker.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 10),
            repeatPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repeatPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repeatPicker.heightAnchor.constraint(equalToConstant: 75),
            
            saveRepeatButton.topAnchor.constraint(equalTo: repeatPicker.bottomAnchor, constant: 10),
            saveRepeatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveRepeatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveRepeatButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Logout Button
            logoutButton.topAnchor.constraint(equalTo: saveRepeatButton.bottomAnchor, constant: 10),
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
        UserDefaults.standard.set(isOn, forKey: "pushNotificationsEnabled")
        
        if (!isOn) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    @objc private func notificationsTimeChanged(_ sender: UIDatePicker) {
        scheduleNotification(at: sender.date, frequency: selectedFrequency)
        UserDefaults.standard.set(sender.date, forKey: "notificationTime")
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
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @objc private func closeSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func savePassword() {
        guard let newPassword = passwordTextField.text, !newPassword.isEmpty else {
            showAlert(message: "Password cannot be empty")
            return
        }
        
        guard newPassword.count >= 8 else {
            showAlert(message: "Password must be at least 8 characters long")
            return
        }
        
        NetworkManager.shared.updateUser(name: nameInfoLabel.text ?? "", email: emailInfoLabel.text ?? "", gender: genderInfoLabel.text ?? "", password: newPassword) { success in
            DispatchQueue.main.async {
                if success {
                    self.showAlert(message: "Password changed successfully")
                    self.passwordTextField.text = ""
                } else {
                    self.showAlert(message: "Password change failed")
                }
            }
        }
    }
    
    @objc private func logout() {
        NetworkManager.shared.logout { success in
            DispatchQueue.main.async {
                if success {
                    self.transitionToLogin()
                } else {
                    NetworkManager.shared.showAlert(message: "Logout failed")
                }
            }
        }
    }
    
    private func transitionToLogin() {
        let loginPageVC = ViewController()
        loginPageVC.modalPresentationStyle = .fullScreen
        present(loginPageVC, animated: true, completion: nil)
    }
    
    @objc private func saveRepeat() {
        UserDefaults.standard.set(selectedFrequency, forKey: repeatFrequencyKey)
        showAlert(message: "Repeat frequency saved successfully")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Settings", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
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
    
    private func fetchUserInfo() {
        NetworkManager.shared.getCurrentUser { data in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let user = jsonObject["user"] as? [String: Any] {
                            self.emailInfoLabel.text = user["email"] as? String
                            self.nameInfoLabel.text = user["name"] as? String
                            self.genderInfoLabel.text = user["gender"] as? String
                        } else {
                            self.showAlert(message: "Failed to load user info: Unexpected response format")
                        }
                    } catch {
                        self.showAlert(message: "Failed to load user info: \(error.localizedDescription)")
                    }
                } else {
                    self.showAlert(message: "Failed to load user info: No data received")
                }
            }
        }
    }
    
    private func restoreSettings() {
        let isPushNotificationsEnabled = UserDefaults.standard.bool(forKey: "pushNotificationsEnabled")
        pushNotificationsSwitch.isOn = isPushNotificationsEnabled
        datePicker.isHidden = !isPushNotificationsEnabled
        repeatLabel.isHidden = !isPushNotificationsEnabled
        repeatPicker.isHidden = !isPushNotificationsEnabled
        saveRepeatButton.isHidden = !isPushNotificationsEnabled
        
        if let notificationTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            datePicker.date = notificationTime
        }
        
        if let frequency = UserDefaults.standard.string(forKey: repeatFrequencyKey) {
            if let index = frequencies.firstIndex(of: frequency) {
                repeatPicker.selectRow(index, inComponent: 0, animated: false)
                selectedFrequency = frequency
            }
        }
    }
}
