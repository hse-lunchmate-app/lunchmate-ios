//
//  AuthenticationViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.06.2024.
//

import UIKit


class AuthenticationViewController: UIViewController {
    
    let viewModel = AuthenticationViewModel()
    
    let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите логин"
        tf.textColor = .black
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(named: "Base20")?.cgColor
        tf.layer.cornerRadius = 8
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    let loginLabel: UILabel = {
        let ll = UILabel()
        ll.text = "Логин"
        ll.font = UIFont(name: "Roboto-Regular", size: 14)
        ll.textColor = UIColor(named: "Base30")
        return ll
    }()
    
    let passwordLabel: UILabel = {
        let pl = UILabel()
        pl.text = "Пароль"
        pl.font = UIFont(name: "Roboto-Regular", size: 14)
        pl.textColor = UIColor(named: "Base30")
        return pl
    }()
    
    let logoLabel: UILabel = {
        let pl = UILabel()
        pl.text = "LunchMate"
        pl.font = UIFont(name: "Roboto-Medium", size: 16)
        pl.textColor = UIColor(named: "Base90")
        return pl
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.textColor = .black
        tf.isSecureTextEntry = true
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(named: "Base20")?.cgColor
        tf.layer.cornerRadius = 8
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    lazy var authButton: UIButton = {
        let ab = UIButton()
        ab.setTitle("Boйти", for: .normal)
        ab.backgroundColor = UIColor(named: "Base15")
        ab.setTitleColor(.white, for: .disabled)
        ab.setTitleColor(.black, for: .normal)
        ab.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)
        ab.layer.cornerRadius = 8
        ab.isEnabled = false
        ab.addTarget(self, action: #selector(makeAutorization), for: .touchUpInside)
        return ab
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "tinkoffBgLabel")
        view.layer.cornerRadius = 24
        return view
    }()
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Base0")
        [logoImageView, logoLabel, backgroundView, loginLabel, passwordLabel, loginTextField, passwordTextField, authButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [passwordTextField, loginTextField].forEach {
            $0.delegate = self
        }
        
        NSLayoutConstraint.activate([
            loginLabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -4),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            backgroundView.heightAnchor.constraint(equalToConstant: 271),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -4),
            passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            passwordLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 8),
            loginTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            loginTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            loginTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            passwordTextField.bottomAnchor.constraint(equalTo: authButton.topAnchor, constant: -24),
            authButton.heightAnchor.constraint(equalToConstant: 52),
            authButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -37.5),
            authButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            authButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 72),
            logoImageView.widthAnchor.constraint(equalToConstant: 72),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height / 5),
            logoLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
        ])
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "isPresentAlert")
    }
    
    @objc func makeAutorization() {
        if let login = loginTextField.text, let password = passwordTextField.text {
            viewModel.getId(login: login, password: password) { [weak self] error in
                if error?.code == 403 {
                    DispatchQueue.main.async {
                        self?.presentAlert()
                    }
                }
                else if error == nil {
                    DispatchQueue.main.async {
                        if let presentingViewController = self?.presentingViewController {
                            self?.dismiss(animated: true)
                        } else {
                            let tabBarController = TabBarController()
                            tabBarController.modalPresentationStyle = .fullScreen
                            self?.loginTextField.text = ""
                            self?.passwordTextField.text = ""
                            self?.authButton.isEnabled = false
                            self?.authButton.backgroundColor = UIColor(named: "Base15")
                            self?.present(tabBarController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let secondTF = textField == loginTextField ? passwordTextField : loginTextField
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if newText != "" && secondTF.text != "" {
            authButton.isEnabled = true
            authButton.backgroundColor = UIColor(named: "Yellow")
        }
        else {
            authButton.isEnabled = false
            authButton.backgroundColor = UIColor(named: "Base15")
        }
        return true
    }
}
