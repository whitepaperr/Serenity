//
//  NotesViewController.swift
//  Serenity
//
//  Created by Kate Muret on 5/29/24.
//

import UIKit

class NotesViewController: UIViewController {
    
    private let textView = UITextView()
    private let saveButton = UIButton()
    private let editButton = UIButton()
    private let dateLabel = UILabel()
    private var isEditingNote = false
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadNote()
        setupSwipeBackGesture()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.textAlignment = .center
        view.addSubview(dateLabel)
        
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        view.addSubview(textView)
        
        setupButton(saveButton, title: "Save", color: UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0), action: #selector(saveNote))
        saveButton.isHidden = true
        
        setupButton(editButton, title: "Edit", color: UIColor(red: 0.796, green: 0.764, blue: 0.890, alpha: 1.0), action: #selector(editNote))
        editButton.isHidden = true
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
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            editButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func loadNote() {
        guard let selectedDate = selectedDate else { return }
        dateLabel.text = formatDate(selectedDate)
        
        if let note = NotesDataManager.shared.getNoteForDate(selectedDate) {
            textView.text = note.text
            textView.isEditable = false
            saveButton.isHidden = true
            editButton.isHidden = false
        } else {
            textView.text = ""
            textView.isEditable = true
            textView.becomeFirstResponder()
            saveButton.isHidden = false
            editButton.isHidden = true
        }
    }
    
    @objc private func saveNote() {
        guard let selectedDate = selectedDate else { return }
        NotesDataManager.shared.saveNoteForDate(selectedDate, text: textView.text)
        textView.isEditable = false
        saveButton.isHidden = true
        editButton.isHidden = false
    }
    
    @objc private func editNote() {
        textView.isEditable = true
        textView.becomeFirstResponder()
        saveButton.isHidden = false
        editButton.isHidden = true
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
