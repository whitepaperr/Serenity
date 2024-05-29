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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createCalendar()
        setupButtons()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        title = "Calendar"
        
        selectedDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
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
            calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        self.selection = selection
        
        if let selectedDate = selectedDate {
            selection.setSelected(selectedDate, animated: false)
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
        let noteVC = NotesViewController()
        noteVC.modalPresentationStyle = .fullScreen
        present(noteVC, animated: true, completion: nil)
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else {
            return
        }
        
        selectedDate = dateComponents
    }
}

