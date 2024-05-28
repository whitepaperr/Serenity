import UIKit

class DataViewController: UIViewController {
    let fetchDataButton = UIButton()
    let createDataButton = UIButton()
    let updateDataButton = UIButton()
    let deleteDataButton = UIButton()
    let dataTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        fetchDataButton.setTitle("Fetch Data", for: .normal)
        fetchDataButton.backgroundColor = .blue
        createDataButton.setTitle("Create Data", for: .normal)
        createDataButton.backgroundColor = .green
        updateDataButton.setTitle("Update Data", for: .normal)
        updateDataButton.backgroundColor = .orange
        deleteDataButton.setTitle("Delete Data", for: .normal)
        deleteDataButton.backgroundColor = .red
        dataTextView.layer.borderColor = UIColor.gray.cgColor
        dataTextView.layer.borderWidth = 1.0
        
        fetchDataButton.addTarget(self, action: #selector(fetchDataButtonTapped), for: .touchUpInside)
        createDataButton.addTarget(self, action: #selector(createDataButtonTapped), for: .touchUpInside)
        updateDataButton.addTarget(self, action: #selector(updateDataButtonTapped), for: .touchUpInside)
        deleteDataButton.addTarget(self, action: #selector(deleteDataButtonTapped), for: .touchUpInside)
        
        fetchDataButton.translatesAutoresizingMaskIntoConstraints = false
        createDataButton.translatesAutoresizingMaskIntoConstraints = false
        updateDataButton.translatesAutoresizingMaskIntoConstraints = false
        deleteDataButton.translatesAutoresizingMaskIntoConstraints = false
        dataTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fetchDataButton)
        view.addSubview(createDataButton)
        view.addSubview(updateDataButton)
        view.addSubview(deleteDataButton)
        view.addSubview(dataTextView)
        
        NSLayoutConstraint.activate([
            fetchDataButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fetchDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchDataButton.widthAnchor.constraint(equalToConstant: 200),
            
            createDataButton.topAnchor.constraint(equalTo: fetchDataButton.bottomAnchor, constant: 20),
            createDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createDataButton.widthAnchor.constraint(equalToConstant: 200),
            
            updateDataButton.topAnchor.constraint(equalTo: createDataButton.bottomAnchor, constant: 20),
            updateDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateDataButton.widthAnchor.constraint(equalToConstant: 200),
            
            deleteDataButton.topAnchor.constraint(equalTo: updateDataButton.bottomAnchor, constant: 20),
            deleteDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteDataButton.widthAnchor.constraint(equalToConstant: 200),
            
            dataTextView.topAnchor.constraint(equalTo: deleteDataButton.bottomAnchor, constant: 20),
            dataTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dataTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dataTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func fetchDataButtonTapped() {
        NetworkManager.shared.fetchData { data in
            DispatchQueue.main.async {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    self.dataTextView.text = responseString
                    print("Fetch data successful: \(responseString)")
                } else {
                    NetworkManager.shared.showAlert(message: "Fetch data failed")
                    print("Fetch data failed")
                }
            }
        }
    }
    
    @objc func createDataButtonTapped() {
        let alertController = UIAlertController(title: "Create Data", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Note"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Duration"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "Date (YYYY-MM-DD HH:MM:SS)"
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            guard let note = alertController.textFields?[0].text,
                  let durationString = alertController.textFields?[1].text, let duration = Int(durationString),
                  let date = alertController.textFields?[2].text else { return }
            NetworkManager.shared.createData(note: note, duration: duration, date: date) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Create data successful")
                        self.fetchDataButtonTapped()
                    } else {
                        NetworkManager.shared.showAlert(message: "Create data failed")
                        print("Create data failed")
                    }
                }
            }
        }
        alertController.addAction(createAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    @objc func updateDataButtonTapped() {
        let alertController = UIAlertController(title: "Update Data", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Data ID"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Note"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Duration"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "Date (YYYY-MM-DD HH:MM:SS)"
        }
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            guard let id = alertController.textFields?[0].text,
                  let note = alertController.textFields?[1].text,
                  let durationString = alertController.textFields?[2].text, let duration = Int(durationString),
                  let date = alertController.textFields?[3].text else { return }
            NetworkManager.shared.updateData(id: id, note: note, duration: duration, date: date) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Update data successful")
                        self.fetchDataButtonTapped()
                    } else {
                        NetworkManager.shared.showAlert(message: "Update data failed")
                        print("Update data failed")
                    }
                }
            }
        }
        alertController.addAction(updateAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc func deleteDataButtonTapped() {
        let alertController = UIAlertController(title: "Delete Data", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Data ID"
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let id = alertController.textFields?[0].text else { return }
            NetworkManager.shared.deleteData(id: id) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Delete data successful")
                        self.fetchDataButtonTapped()
                    } else {
                        NetworkManager.shared.showAlert(message: "Delete data failed")
                        print("Delete data failed")
                    }
                }
            }
        }
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
