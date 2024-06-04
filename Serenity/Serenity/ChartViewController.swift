//
//  ChartViewController.swift
//  Serenity
//
//  Created by Kate Muret on 5/29/24.
//

import UIKit
import SwiftUI
import Charts

struct WeeklyMeditationData: Identifiable {
    var week: String
    var duration: Double
    var id = UUID()
}

struct BarChart: View {
    var data: [WeeklyMeditationData]
    
    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Week", item.week),
                y: .value("Duration (minutes)", item.duration)
            )
            .foregroundStyle(Color(red: 0.758, green: 0.694, blue: 0.882))
        }
        .chartXAxisLabel("Weeks")
        .chartYAxisLabel("Minutes")
        .padding()
    }
}

class ChartViewController: UIViewController {
    private var weeklyData: [WeeklyMeditationData] = [] {
        didSet {
            updateChart()
        }
    }
    private var currentDate: Date = Date()
    private let monthLabel = UILabel()
    private var datesWithEntries: Set<DateComponents> = []
    private var chartHostingController: UIHostingController<BarChart>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchDataAndUpdateChart(for: currentDate)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.988, alpha: 1.0)
        title = "Meditation Progress"
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        backButton.backgroundColor = UIColor(red: 0.90, green: 0.85, blue: 0.96, alpha: 1.00)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        let prevMonthButton = UIButton(type: .system)
        prevMonthButton.setTitle("<", for: .normal)
        prevMonthButton.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        prevMonthButton.addTarget(self, action: #selector(showPreviousMonth), for: .touchUpInside)
        prevMonthButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prevMonthButton)
        
        let nextMonthButton = UIButton(type: .system)
        nextMonthButton.setTitle(">", for: .normal)
        nextMonthButton.setTitleColor(UIColor(red: 0.29, green: 0.18, blue: 0.51, alpha: 1.00), for: .normal)
        nextMonthButton.addTarget(self, action: #selector(showNextMonth), for: .touchUpInside)
        nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextMonthButton)
        
        monthLabel.text = formattedMonth(currentDate)
        monthLabel.textAlignment = .center
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            prevMonthButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            prevMonthButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            prevMonthButton.widthAnchor.constraint(equalToConstant: 40),
            prevMonthButton.heightAnchor.constraint(equalToConstant: 40),
            
            nextMonthButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            nextMonthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextMonthButton.widthAnchor.constraint(equalToConstant: 40),
            nextMonthButton.heightAnchor.constraint(equalToConstant: 40),
            
            monthLabel.centerYAnchor.constraint(equalTo: prevMonthButton.centerYAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: prevMonthButton.trailingAnchor, constant: 10),
            monthLabel.trailingAnchor.constraint(equalTo: nextMonthButton.leadingAnchor, constant: -10)
        ])
        
        chartHostingController = UIHostingController(rootView: BarChart(data: weeklyData))
        addChild(chartHostingController!)
        chartHostingController!.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartHostingController!.view)
        
        NSLayoutConstraint.activate([
            chartHostingController!.view.topAnchor.constraint(equalTo: prevMonthButton.bottomAnchor, constant: 10),
            chartHostingController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            chartHostingController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chartHostingController!.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
        ])
        
        chartHostingController!.didMove(toParent: self)
    }
    
    private func updateChart() {
        chartHostingController?.rootView = BarChart(data: weeklyData)
    }
    
    @objc private func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func showPreviousMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        monthLabel.text = formattedMonth(currentDate)
        fetchDataAndUpdateChart(for: currentDate)
    }
    
    @objc private func showNextMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        monthLabel.text = formattedMonth(currentDate)
        fetchDataAndUpdateChart(for: currentDate)
    }
    
    private func fetchDataAndUpdateChart(for month: Date) {
        NetworkManager.shared.fetchData { data in
            DispatchQueue.main.async {
                guard let data = data else {
                    print("Failed to fetch data")
                    return
                }
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    guard let dataArray = jsonObject?["data"] as? [[String: Any]] else {
                        print("Failed to parse data")
                        return
                    }
                    print("Fetched data: \(dataArray)") // Print fetched data for debugging
                    self.updateEntriesForAllMonths(with: dataArray, for: month)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
    }

    private func updateEntriesForAllMonths(with dataArray: [[String: Any]], for month: Date) {
        var groupedData: [Int: Double] = [:]
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let currentCalendar = Calendar.current
        // Calculate the first and last day of the month
        
        for entry in dataArray {
            if let dateString = entry["date"] as? String, let date = dateFormatter.date(from: dateString) {
                let components = currentCalendar.dateComponents([.year, .month, .day], from: date)
                print("Parsed DateComponents: \(components)") // Debugging statement
                self.datesWithEntries.insert(components)
            }
        }
        
        let startDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        guard let startDate = calendar.date(from: startDateComponents),
              let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) else {
            return
        }
        
        // Calculate the range of weeks based on the first and last day of the month
        guard let monthRange = calendar.range(of: .weekOfMonth, in: .month, for: month),
              let firstWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: startDate),
              let lastWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: endDate) else {
            return
        }
        let numberOfWeeks = (monthRange.count - 1) + (lastWeekday < firstWeekday ? 1 : 0) // Adjust for partial weeks
        
        // Group data by week
        for entry in dataArray {
            if let dateString = entry["date"] as? String,
               let date = dateFormatter.date(from: dateString),
               calendar.isDate(date, equalTo: month, toGranularity: .month) {
                let weekOfMonth = calendar.component(.weekOfMonth, from: date)
                let duration = entry["duration"] as? Double ?? 0.0
                groupedData[weekOfMonth, default: 0.0] += duration
            }
        }
        
        // Populate weeklyData
        var newWeeklyData: [WeeklyMeditationData] = []
        for week in 1...numberOfWeeks {
            let duration = groupedData[week] ?? 0.0
            newWeeklyData.append(WeeklyMeditationData(week: "Week \(week)", duration: duration))
        }
        
        // Summarize total minutes for the month
        let totalMinutes = newWeeklyData.reduce(0) { $0 + $1.duration }
        
        // Update the data
        self.weeklyData = newWeeklyData
    }

    private func formattedMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
