//
//  LoginController.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LoginCellDelegate {
    
    
    let loginCellId = "loginCellId"
    let registerCellId = "registerCellId"
    
    var registerCell:RegisterCell?
    var loginCell: LoginCell?
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.loginController = self
        return mb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        observeKeyboard()
    }
    
    func scrollTo(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalViewLeftAnchor?.constant = scrollView.contentOffset.x / 2
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let item = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: item, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
    
    
    // Keyboard
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardShow(notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            let indexPath = self.collectionView.indexPathsForVisibleItems
            if indexPath[0].item == 0  {
                self.collectionView.frame = CGRect(x: 0, y: -90, width: self.view.frame.width, height: self.view.frame.height)
            } else {
                self.collectionView.frame = CGRect(x: 0, y: -120, width: self.view.frame.width, height: self.view.frame.height)
            }
        }
    }
    
    @objc private func keyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    @objc private func handleLoginInformationChanged() {
        guard let loginCell = self.loginCell else { return }
        
        let isFormValid = loginCell.loginTextField.text?.characters.count ?? 0 > 0 && loginCell.passwordTextField.text?.characters.count ?? 0 > 0
        if isFormValid {
            loginCell.loginButton.isEnabled = true
            loginCell.loginButton.backgroundColor = UIColor.mainGreen()
        } else {
            loginCell.loginButton.isEnabled = false
            loginCell.loginButton.backgroundColor = UIColor.mainGray()
        }
    }
    
    @objc func handleSignUpInformationChanged() {
        guard let registerCell = self.registerCell else { return }
        let isFormValid = registerCell.loginTextField.text?.characters.count ?? 0 > 0 &&
            registerCell.passwordTextField.text?.characters.count ?? 0 > 0 &&
            registerCell.repeatPasswordField.text?.characters.count ?? 0 > 0
            //&& registerCell.passwordTextField.text == registerCell.repeatPasswordField.text
        
        if isFormValid {
            registerCell.signUpButton.isEnabled = true
            registerCell.signUpButton.backgroundColor = UIColor.mainGreen()
        } else {
            registerCell.signUpButton.isEnabled = false
            registerCell.signUpButton.backgroundColor = UIColor.mainGray()
        }
    }
    
    // Authorization
    
    func finishLogingIn() {
        
        guard let login = loginCell?.loginTextField.text?.lowercased() else { return }
        print(login)
        guard let password = loginCell?.passwordTextField.text else { return }
        
        API.shared.logingIn(login: login, password: password, completion: { success, response, error in
            if success {
                DispatchQueue.main.async {
                    
                    let token = response?["data"]["token"].stringValue
                    UserDefaults.standard.setValue(token, forKey: "token")
                    let login = response?["data"]["login"].stringValue
                    UserDefaults.standard.setValue(login, forKey: "login")
                    
                    let storyboard = UIStoryboard(name: "SWReveal", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                    self.present(viewController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Try again", message: error, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })}
    
    func finishSignUp() {
        
        if registerCell?.passwordTextField.text != registerCell?.repeatPasswordField.text {
            let alert = UIAlertController(title: "Try again", message: "Passwords don't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
        
        guard let login = registerCell?.loginTextField.text?.lowercased() else { return }
        guard let password = registerCell?.passwordTextField.text else { return }
        
        API.shared.signUp(login: login, password: password, completion: { success, response, error in
            if success {
                DispatchQueue.main.async {
                    
                    let token = response?["data"]["token"].stringValue
                    UserDefaults.standard.setValue(token, forKey: "token")
                    let login = response?["data"]["login"].stringValue
                    UserDefaults.standard.setValue(login, forKey: "login")
                    
                    let storyboard = UIStoryboard(name: "SWReveal", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                    self.present(viewController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Try again", message: error, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
     }
    }
    // Collection View
    
    private func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.mainLightGray()
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
        collectionView.register(RegisterCell.self, forCellWithReuseIdentifier: registerCellId)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        view.addSubview(menuBar)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        menuBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        print(menuBar)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            cell.loginController = self
            self.loginCell = cell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: registerCellId, for: indexPath) as! RegisterCell
            cell.loginController = self
            self.registerCell = cell
            return cell
        }
    }
}


