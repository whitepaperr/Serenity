//
//  CalendarViewController.swift
//  Serenity
//
//  Created by Kate Muret on 5/28/24.
//

import UIKit

class CalendarViewController: UIViewController {
    
    private var selectedDate: DateComponents?
    private let calendarView = UICalendarView()
    private var selection: UICalendarSelectionSingleDate?
    private let graphProgressButton = UIButton()
    private let dayNotesButton = UIButton()
    private let backButton = UIButton()
    
    private var datesWithEntries: Set<DateComponents> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createCalendar()
        setupButtons()
        setupSwipeBackGesture()
        fetchData()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        title = "Calendar"
        
        selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        setupBackButton()
    }
    
    private func setupBackButton() {
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        backButton.backgroundColor = UIColor(red: 0.90, green: 0.85, blue: 0.96, alpha: 1.00)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
        
    @objc private func navigateBack() {
        dismiss(animated: true, completion: nil)
    }

    private func createCalendar() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.tintColor = UIColor(red: 0.66, green: 0.52, blue: 0.84, alpha: 1.00)
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = .systemBackground
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            calendarView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10)
        ])
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        self.selection = selection
        
        // Set the initial selection to the current date
        if let selectedDate = selectedDate {
            selection.setSelected(selectedDate, animated: false)
        } else {
            let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            selection.setSelected(currentDate, animated: false)
            selectedDate = currentDate // Update the selectedDate property
        }
    }
    
    private func setupButtons() {
        setupButton(graphProgressButton, title: "Graph Progress Chart", color: UIColor(red: 0.90, green: 0.85, blue: 0.96, alpha: 1.00), action: #selector(openChartView))
        setupButton(dayNotesButton, title: "Day Notes", color: UIColor(red: 0.73, green: 0.87, blue: 0.97, alpha: 1.00), action: #selector(openNotesView))

        
        NSLayoutConstraint.activate([
            graphProgressButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            graphProgressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            graphProgressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            graphProgressButton.heightAnchor.constraint(equalToConstant: 50),
            
            dayNotesButton.topAnchor.constraint(equalTo: graphProgressButton.bottomAnchor, constant: 20),
            dayNotesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dayNotesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dayNotesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String, color: UIColor, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    @objc private func openChartView() {
        let chartVC = ChartViewController()
        chartVC.modalPresentationStyle = .fullScreen
        present(chartVC, animated: true, completion: nil)
    }

    @objc private func openNotesView() {
        guard let selectedDate = selectedDate else { return }
        let noteVC = NotesViewController()
        noteVC.selectedDate = selectedDate
        noteVC.modalPresentationStyle = .fullScreen
        present(noteVC, animated: true, completion: nil)
    }

    private func fetchData() {
        NetworkManager.shared.fetchData { data in
            DispatchQueue.main.async {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let dataArray = jsonObject["data"] as? [[String: Any]] else {
                        return
                    }
                    self.datesWithEntries.removeAll()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    let currentCalendar = Calendar.current
                    let currentYear = currentCalendar.component(.year, from: Date())
                    
                    for entry in dataArray {
                        if let dateString = entry["date"] as? String,
                           let date = dateFormatter.date(from: dateString) {
                            let components = currentCalendar.dateComponents([.year, .month, .day], from: date)
                            if components.year == currentYear {
                                self.datesWithEntries.insert(components)
                            }
                        } else {
                            // Handle parsing failure if needed
                        }
                    }
                    self.calendarView.reloadDecorations(forDateComponents: Array(self.datesWithEntries), animated: true)
                } else {
                    NetworkManager.shared.showAlert(message: "Fetch data failed")
                }
            }
        }
    }

    private func updateEntriesForAllMonths(with dataArray: [[String: Any]]) {
        self.datesWithEntries.removeAll()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let currentCalendar = Calendar.current
        for entry in dataArray {
            if let dateString = entry["date"] as? String,
               let date = dateFormatter.date(from: dateString) {
                let components = currentCalendar.dateComponents([.year, .month, .day], from: date)
                self.datesWithEntries.insert(components)
            }
        }
        print("Dates with entries: \(self.datesWithEntries)")
        
        // Debugging: Check for duplicate or missing dates
        for dateComponents in self.datesWithEntries {
            print("Adding dot for date: \(dateComponents)")
        }
        
        self.calendarView.reloadDecorations(forDateComponents: Array(self.datesWithEntries), animated: true)
    }

}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if datesWithEntries.contains(where: { $0.year == dateComponents.year && $0.month == dateComponents.month && $0.day == dateComponents.day }) {
            print("Adding dot for date: \(dateComponents)") // Debugging statement
            return UICalendarView.Decoration.default(color: UIColor(red: 0.66, green: 0.52, blue: 0.84, alpha: 1.00), size: .large)
        }
        return nil
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else {
            return
        }
        
        selectedDate = dateComponents
        print("Selected date: \(date)") // Print the selected date
    }
}

