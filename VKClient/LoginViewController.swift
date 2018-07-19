//
//  LoginViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 13.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: - Class funcs
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureDidTap))
        
        mainScrollView.addGestureRecognizer(tapGestureRecognizer)
        
        // сначала удалить(защитимся от возможного повторного вызова viewWillAppear)
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
    }
    
    func newFeature(){
        let asd = "tree"
        print(asd)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if !checkUserData() {
            showAlert("Вход запрещен. Неверный логин или пароль")
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Actions
    @IBAction func unwindSegue(seque: UIStoryboardSegue){
        
    }
    
    @objc private func tapGestureDidTap() {
        mainScrollView.endEditing(false)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            mainScrollView.contentInset             = contentInsets
            mainScrollView.scrollIndicatorInsets    = contentInsets
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        let contentInsets = UIEdgeInsets.zero
        mainScrollView.contentInset             = contentInsets
        mainScrollView.scrollIndicatorInsets    = contentInsets
        
    }
    
    // MARK: Functions
    private func checkUserData() -> Bool {
        guard let login = loginTextField.text,
            let password = passwordTextField.text else {
                return false
        }
        return (login == "admin" && password == "123")
    }
    
    private func showAlert(_ message: String) {
        
        let alertDialog = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alertDialog.addAction(okeyButton)
        
        present(alertDialog, animated: true, completion: nil)
        
    }
    
}
