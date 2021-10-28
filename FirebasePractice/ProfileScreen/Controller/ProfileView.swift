//
//  ProfileView.swift
//  tableViewMusic
//
//  Created by pro2017 on 16/10/2021.
//

import UIKit
import Firebase

class ProfileView: UIViewController {
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        
        // Выйти из аккаунта
        do {
            try Auth.auth().signOut()
            
            // Вызываем метод по открытию основного экрана
            openSignInView()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    private func setupView() {
        
        self.logOutButton.layer.cornerRadius = 10
        
        // Получаем данные пользователя
        fetchCurrentUserInfo()
        
    }
    
    private func openSignInView() {
        
        if Auth.auth().currentUser == nil {
             
            self.dismiss(animated: true)
        }
        
    }
    
    fileprivate func fetchCurrentUserInfo() {
        
        if Auth.auth().currentUser != nil {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference()
                .child("users")
                .child(uid)
                .observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    
                    guard let currentUserData = snapshot.value as? [String: Any] else { return }
                    
                    guard let user = CurrentUser(currentUserData: currentUserData, uid: uid) else { return }
                    
                    self?.personLabel.text = "Hello \(user.name), your email: \(user.email)"
                    
                }
        }
    }
}
