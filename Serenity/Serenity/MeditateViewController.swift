//
//  MeditateViewController.swift
//  Serenity
//
//  Created by Tammy Nguyen on 5/27/24.
//

import UIKit

class MeditateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let logoImageView = UIImageView()
    let timerImageView = UIImageView()
    let dateLabel = UILabel()
    let timerLabel = UILabel()
    let startButton = UIButton()
    let pauseButton = UIButton()
    let resetButton = UIButton()
    let calendarButton = UIButton()
    let musicRecButton = UIButton()
    
    // TEMP
    // let apiTestButton = UIButton()
    
    let settingsButton = UIButton(type: .system)
    let durationPicker = UIPickerView()

    var countdownTimer: Timer?
    var totalTime = 0
    var currentTime: Int = 0
    var isCounterActive = false
    let hoursOptions = Array(0...23)
    let minutesOptions = Array(0...59)
    let secondsOptions = Array(0...59)
    let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        resetTimer()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)

        // Logo
        logoImageView.image = UIImage(named: "Serenity")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        // Timer Img
        timerImageView.image = UIImage(named: "Timer")
        timerImageView.contentMode = .scaleAspectFit
        view.addSubview(timerImageView)

        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.textAlignment = .center
        //dateLabel.textColor = .white
        view.addSubview(dateLabel)

        // Timer Label
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 32)
        timerLabel.textColor = .white
        timerImageView.addSubview(timerLabel)
        
        // Duration Picker
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationPicker.backgroundColor = .clear
        view.addSubview(durationPicker)

        // Start Button
        setupButton(startButton, title: "Start", action: #selector(startTimer))
        
        // Pause Button
        setupButton(pauseButton, title: "Pause", action: #selector(pauseTimer))
        
        // Reset Button
        setupButton(resetButton, title: "Reset", action: #selector(resetTimer))

        // Button Stack
        let buttonStackView = UIStackView(arrangedSubviews: [startButton, pauseButton, resetButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        view.addSubview(buttonStackView)

        // Calendar Button
        setupButton(calendarButton, title: "Calendar")
        calendarButton.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        view.addSubview(calendarButton)
        
        // Music Recommendation Button
        setupButton(musicRecButton, title: "Music Recs")
        musicRecButton.addTarget(self, action: #selector(openMusicRecs), for: .touchUpInside)
        view.addSubview(calendarButton)
        
        // TEMP
        // setupButton(apiTestButton, title: "apiTest", action: #selector(apiTestButtonTapped))

        // Settings Button
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        view.addSubview(settingsButton)
    }
    
    // TEMP
    @objc func apiTestButtonTapped() {
        let mainViewController = APITestViewController()
        present(mainViewController, animated: true, completion: nil)
    }

    private func setupButton(_ button: UIButton, title: String, action: Selector? = nil) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0)
        button.layer.cornerRadius = 10
        // button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        view.addSubview(button)
    }

    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        durationPicker.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        musicRecButton.translatesAutoresizingMaskIntoConstraints = false
        
        // TEMP
       // apiTestButton.translatesAutoresizingMaskIntoConstraints = false
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

        let buttonStackView = UIStackView(arrangedSubviews: [startButton, pauseButton, resetButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 50),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Date
            dateLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Timer Img
            timerImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            timerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            timerImageView.widthAnchor.constraint(equalToConstant: 300),
            timerImageView.heightAnchor.constraint(equalToConstant: 300),

            // Timer Label
            timerLabel.centerXAnchor.constraint(equalTo: timerImageView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerImageView.centerYAnchor),

            // Duration Picker
            durationPicker.topAnchor.constraint(equalTo: timerImageView.bottomAnchor, constant: 2),
            durationPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            durationPicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            durationPicker.heightAnchor.constraint(equalToConstant: 100),

            // Start, Pause, Reset Buttons
            buttonStackView.topAnchor.constraint(equalTo: durationPicker.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),

            // Calendar Button
            calendarButton.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            calendarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
            calendarButton.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),

            // Music Button
            musicRecButton.topAnchor.constraint(equalTo: calendarButton.bottomAnchor, constant: 20),
            musicRecButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musicRecButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
            musicRecButton.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),
            
            // TEMP
//            apiTestButton.topAnchor.constraint(equalTo: musicRecButton.bottomAnchor, constant: 20),
//            apiTestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            apiTestButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
//            apiTestButton.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),

            // Settings Button
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupTimer() {
        currentTime = totalTime
        updateTimerLabel()
    }

    private func updateTimerLabel() {
        let hours = currentTime / 3600
        let minutes = (currentTime % 3600) / 60
        let seconds = currentTime % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    @objc private func startTimer() {
        if countdownTimer == nil {
            isCounterActive = true
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateTimer() {
        if currentTime > 0 && isCounterActive {
            currentTime -= 1
            updateTimerLabel()
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            isCounterActive = false
            stopTimer() // Call stopTimer when the timer runs out
        }
    }

    @objc private func pauseTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCounterActive = false
        stopTimer() // Call stopTimer when the timer is paused
    }

    @objc private func stopTimer() {
        if !isCounterActive {
            // Log the meditation session with the current duration
            logMeditationSession(duration: totalTime - currentTime)
        }
    }


    @objc private func resetTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        currentTime = totalTime
        isCounterActive = false
        updateTimerLabel()
    }

    private func logMeditationSession(duration: Int) {
        // Get the current date and time
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ISO 8601 format with time
        let dateString = dateFormatter.string(from: currentDate)
        
        // Call the API to log the meditation session
        networkManager.createData(note: "Meditation session", duration: duration, date: dateString) { success in
            if success {
                print("Meditation session logged successfully.")
                NetworkManager.shared.fetchData { data in
                    DispatchQueue.main.async {
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            // Display fetched data in an alert
                            print("Fetch data successful: \(responseString)")
                        } else {
                            NetworkManager.shared.showAlert(message: "Fetch data failed")
                            print("Fetch data failed")
                        }
                    }
                }
                // You can optionally perform any UI updates or additional actions here
            } else {
                print("Failed to log meditation session.")
                // Handle error or display an alert to the user
            }
        }
    }

    @objc private func openSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true, completion: nil)
    }
    
    @objc private func openCalendar() {
        let calendarVC = CalendarViewController()
        calendarVC.modalPresentationStyle = .fullScreen
        present(calendarVC, animated: true, completion: nil)
    }

    @objc private func openMusicRecs() {
        let musicVC = MusicViewController()
        musicVC.modalPresentationStyle = .fullScreen
        present(musicVC, animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hoursOptions.count
        case 1:
            return minutesOptions.count
        case 2:
            return secondsOptions.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(hoursOptions[row]) hr"
        case 1:
            return "\(minutesOptions[row]) min"
        case 2:
            return "\(secondsOptions[row]) sec"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHours = hoursOptions[durationPicker.selectedRow(inComponent: 0)]
        let selectedMinutes = minutesOptions[durationPicker.selectedRow(inComponent: 1)]
        let selectedSeconds = secondsOptions[durationPicker.selectedRow(inComponent: 2)]
        totalTime = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        currentTime = totalTime
        updateTimerLabel()
    }

}
