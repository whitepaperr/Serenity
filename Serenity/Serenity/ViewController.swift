//
//  ViewController.swift
//  Serenity
//
//  Created by 이하은 on 5/24/24.
//

import UIKit

class ViewController: UIViewController {

    let logoImageView = UIImageView()
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let signUpTransitionButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let meditationGif = UIImage.gifImageWithName("meditation")
        logoImageView.image = meditationGif
        setupViews()
        setupConstraints()
        setupSwipeBackGesture()
        updateLoginButtonState()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.94, green: 0.91, blue: 0.90, alpha: 1.00)

        //logoImageView.image = UIImage(named: "Serenity")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        setupTextField(idTextField, placeholder: "Email")
        setupTextField(passwordTextField, placeholder: "Password", isSecure: true)
        
        // TEMP
        idTextField.text = "admin@admin.com"
        passwordTextField.text = "secret123"

        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(loginButton)

        let signUpText = NSMutableAttributedString(string: "You don't have an account? Then, ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        signUpText.append(NSAttributedString(string: "Sign Up", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        signUpTransitionButton.setAttributedTitle(signUpText, for: .normal)
        signUpTransitionButton.setTitleColor(.blue, for: .normal)
        signUpTransitionButton.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        view.addSubview(signUpTransitionButton)

        [idTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
    }

    private func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        view.addSubview(textField)
    }

    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpTransitionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),

            idTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            idTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            idTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            idTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: idTextField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            signUpTransitionButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpTransitionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func loginAction() {
        guard let email = idTextField.text, let password = passwordTextField.text else {
            return
        }
        NetworkManager.shared.login(email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.transitionToMainPage()
                }
            }
        }
    }

    private func transitionToMainPage() {
        let mainPageVC = MeditateViewController()
        mainPageVC.modalPresentationStyle = .fullScreen
        present(mainPageVC, animated: true, completion: nil)
    }
    
    @objc private func showSignUp() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }

    @objc private func editingChanged(_ textField: UITextField) {
        updateLoginButtonState()
    }

    private func updateLoginButtonState() {
        let isEnabled = !(idTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
        loginButton.isEnabled = isEnabled
        loginButton.backgroundColor = isEnabled ? UIColor(red: 0.758, green: 0.694, blue: 0.882, alpha: 1.0) : UIColor(red: 0.796, green: 0.764, blue: 0.890, alpha: 1.0)
    }
}
