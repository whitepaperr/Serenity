import UIKit

class APITestViewController: UIViewController {
    let fetchDataButton = UIButton()
    let logoutButton = UIButton()
    let manageDataButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    func setupViews() {
        fetchDataButton.setTitle("Fetch Current User Data", for: .normal)
        fetchDataButton.backgroundColor = .blue
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .red
        manageDataButton.setTitle("Manage Data", for: .normal)
        manageDataButton.backgroundColor = .gray

        fetchDataButton.addTarget(self, action: #selector(fetchDataButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        manageDataButton.addTarget(self, action: #selector(manageDataButtonTapped), for: .touchUpInside)

        fetchDataButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        manageDataButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(fetchDataButton)
        view.addSubview(logoutButton)
        view.addSubview(manageDataButton)

        NSLayoutConstraint.activate([
            fetchDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchDataButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            fetchDataButton.widthAnchor.constraint(equalToConstant: 200),

            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: fetchDataButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),

            manageDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            manageDataButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20),
            manageDataButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc func fetchDataButtonTapped() {
        NetworkManager.shared.getCurrentUser { data in
            DispatchQueue.main.async {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Fetch current user data successful: \(responseString)")
                } else {
                    NetworkManager.shared.showAlert(message: "Fetch current user data failed")
                    print("Fetch current user data failed")
                }
            }
        }
    }

    @objc func logoutButtonTapped() {
        NetworkManager.shared.logout { success in
            DispatchQueue.main.async {
                if success {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    NetworkManager.shared.showAlert(message: "Logout failed")
                    print("Logout failed")
                }
            }
        }
    }

    @objc func manageDataButtonTapped() {
        let dataViewController = DataViewController()
        navigationController?.pushViewController(dataViewController, animated: true)
        self.present(dataViewController, animated: true, completion: nil)
    }
}
