//
//  SignInEmailView.swift
//  Networking
//
//  Created by pro2017 on 14/10/2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignInEmailView: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView?
    
    // Создаем кнопку для входа
    lazy var continiueButton: UIButton = {
        
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - 100)
        
        button.setTitle("Continiue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.darkGray, for: .normal)
        
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(performSignInAction), for: .touchUpInside)
        
        return button
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
                // Переходим на основной экран
                self.performSegue(withIdentifier: "ShowMain", sender: self)
            }
        }
        
        setupView()
        isButtonEnable(enable: false)
        
        // Добавляем селекторов для textView, что бы можно было проверять введенный текст
        self.emailTF.addTarget(self, action: #selector(tfAction), for: .editingChanged)
        self.passwordTF.addTarget(self, action: #selector(tfAction), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
                // Переходим на основной экран
                self.performSegue(withIdentifier: "ShowMain", sender: self)
            }
        }
        
        // Добавляем обзервера, что бы можно было определить высоту клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    
    private func setupView() {
        self.emailTF.setBottomBorder(with: .white)
        self.passwordTF.setBottomBorder(with: .white)
        
        self.view.addSubview(continiueButton)
        
        // Добавляем activityIndicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continiueButton.center
        
        self.activityIndicator = activityIndicator
        self.view.addSubview(self.activityIndicator!)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        
        // Получаем размеры клавиатуры
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continiueButton.center = CGPoint(x: self.view.center.x , y: self.view.frame.height - keyboardFrame.height - 16 - self.continiueButton.frame.height / 2 )
        
        activityIndicator!.center = CGPoint(x: self.view.center.x , y: self.view.frame.height - keyboardFrame.height - 16 - self.activityIndicator!.frame.height / 2 )
        
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        
        continiueButton.center = CGPoint(x: self.view.center.x , y: self.view.frame.height - 100 )
        
        activityIndicator!.center = CGPoint(x: self.view.center.x , y: self.view.frame.height - 100 )
    }
    
    @objc func tfAction() {
        
        guard
            let email = emailTF.text,
            let password = passwordTF.text
        else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty)
        
        self.isButtonEnable(enable: formFilled)
    }
    
    private func isButtonEnable(enable: Bool) {
        
        if enable {
            self.continiueButton.alpha = 1
            self.continiueButton.isEnabled = true
        } else {
            self.continiueButton.alpha = 0.5
            self.continiueButton.isEnabled = false
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func performSignInAction() {
        
        self.isButtonEnable(enable: false)
        continiueButton.setTitle("", for: .normal)
        activityIndicator?.startAnimating()
        activityIndicator?.hidesWhenStopped = true
        signUpButton.isEnabled = false
        
        // Извлекаем имя и пароль
        guard
            let email = emailTF.text,
            let password = passwordTF.text
        else { return }
        
        // Вход пользователя
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            
            // Обрабатываем ошибку
            if let error = error {
                print(error.localizedDescription)
                
                self?.isButtonEnable(enable: true)
                self?.continiueButton.setTitle("Continiue", for: .normal)
                self?.activityIndicator?.stopAnimating()
                self?.signUpButton.isEnabled = true
                
                return
            }
            //self?.presentingViewController?.dismiss(animated: true)
            self?.performSegue(withIdentifier: "ShowMain", sender: self)
            
        }
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ShowMain" else { return }
        
        // Очищаем поля и активируем кнопку
        self.emailTF.text = ""
        self.passwordTF.text = ""
        
        self.isButtonEnable(enable: true)
        self.continiueButton.setTitle("Continiue", for: .normal)
        self.activityIndicator?.stopAnimating()
        self.signUpButton.isEnabled = true
    }
    
    @IBAction func unwindSegue(with segue: UIStoryboardSegue) {
//        print("hehe")
//        self.performSegue(withIdentifier: "ShowMain", sender: self)
    }
    
}
