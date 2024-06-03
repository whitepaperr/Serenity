//
//  NotesViewController.swift
//  Serenity
//
//  Created by Kate Muret on 5/29/24.
//

import UIKit

class NotesViewController: UIViewController {
    
    private let textView = UITextView()
    private let dateLabel = UILabel()
    private var saveButton: UIButton?
    private var editButton: UIButton?
    private var isEditingNote = false
    var thisDate: String?
    var thisDuration: Int?
    var entryID: String?
    var selectedDate: DateComponents?
    var noteText: String?
    private var didMeditateToday = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchAndDisplayData()
        setupSwipeBackGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.textColor = UIColor(red: 0.64, green: 0.57, blue: 0.75, alpha: 1.00)
        dateLabel.textAlignment = .center
        if let selectedDate = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "LLLL d, yyyy"
            if let date = Calendar.current.date(from: selectedDate) {
                let formattedDate = formatter.string(from: date)
                dateLabel.text = formattedDate
            }
        }
        view.addSubview(dateLabel)
        
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        view.addSubview(textView)
        
        // Add the back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        backButton.backgroundColor = UIColor(red: 0.90, green: 0.85, blue: 0.96, alpha: 1.00)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        // Add constraints for the back button
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String, color: UIColor, action: Selector) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.67)
        ])
    }
    
    private func addButtons() {
        saveButton = UIButton()
        editButton = UIButton()
        
        guard let saveButton = saveButton, let editButton = editButton else { return }
        
        setupButton(saveButton, title: "Save", color: UIColor(red: 0.31, green: 0.51, blue: 0.75, alpha: 1.00), action: #selector(saveNote))
        setupButton(editButton, title: "Edit", color: UIColor(red: 0.73, green: 0.87, blue: 0.97, alpha: 1.00), action: #selector(editNote))
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            editButton.widthAnchor.constraint(equalToConstant: 100),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    private func fetchAndDisplayData() {
        guard let selectedDate = selectedDate else {
            print("Selected date is nil")
            return
        }
        
        NetworkManager.shared.fetchData { data in
            DispatchQueue.main.async {
                if let data = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataArray = jsonObject["data"] as? [[String: Any]] {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    var entryFound = false
                    
                    for entry in dataArray {
                        if let dateString = entry["date"] as? String,
                           let date = dateFormatter.date(from: dateString) {
                            let entryDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                            if entryDateComponents.year == selectedDate.year &&
                               entryDateComponents.month == selectedDate.month &&
                               entryDateComponents.day == selectedDate.day {
                                print("Data entry for selected date: \(entry)")
                                entryFound = true
                                // Display data on UI
                                
                                // Extract the entry details as fields
                                if let note = entry["note"] as? String {
                                    self.noteText = note
                                    self.textView.text = note
                                }
                                if let thisDate = entry["date"] as? String {
                                    self.thisDate = thisDate
                                }
                                if let thisDuration = entry["duration"] as? Int {
                                    self.thisDuration = thisDuration
                                    self.didMeditateToday = thisDuration > 0
                                } else {
                                    print("No note found for the selected date.")
                                }
                                
                                // Extract and return the _id of the data entry
                                if let entryID = entry["_id"] as? String {
                                    self.entryID = entryID
                                }
                                
                                if self.didMeditateToday {
                                    self.addButtons()
                                }
                                return
                            }
                        }
                    }
                    
                    if !entryFound {
                        print("No data entry found for the selected date.")
                    }
                } else {
                    NetworkManager.shared.showAlert(message: "Fetch data failed")
                }
            }
        }
    }


    @objc private func saveNote() {
        //if you hit save note before editing, shouldn't do anything
    }
            
    @objc private func editNote() {
        guard didMeditateToday else {
            return
        }
        
        textView.isEditable = true
        saveButton?.isHidden = false
        editButton?.isHidden = true
        
        saveButton?.removeTarget(self, action: #selector(saveNote), for: .touchUpInside)
        saveButton?.addTarget(self, action: #selector(saveEditedNote), for: .touchUpInside)
    }

    
    @objc private func saveEditedNote() {
        noteText = textView.text

        if let editedNote = noteText {
            if let entryID = entryID {
                if let duration = thisDuration { //need to safely unwrap from Int? to Int
                    NetworkManager.shared.updateData(id: entryID, note: editedNote, duration: duration, date: thisDate ?? "", completion: { success in
                        if success {
                        } else {
                            print("failure")
                        }
                    })
                } else {
                    print("Duration is nil")
                }
            }
        }
        
        textView.isEditable = false
        
        // Hide the save button and show the edit button
        saveButton?.isHidden = true
        editButton?.isHidden = false
        
        saveButton?.removeTarget(self, action: #selector(saveEditedNote), for: .touchUpInside)
        saveButton?.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
}
