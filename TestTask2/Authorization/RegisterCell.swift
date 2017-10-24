//
//  RegisterCell.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class RegisterCell: BaseCollectionViewCell {
    weak var loginController: LoginController?
    
    
    
    let loginTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Login"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.textColor = UIColor.gray
        tf.addTarget(self, action: #selector(handleSignUpInformationChanged), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "******"
        tf.isSecureTextEntry = true
        tf.textColor = UIColor.gray
        tf.addTarget(self, action: #selector(handleSignUpInformationChanged),for: .editingChanged)
        return tf
    }()
    
    let repeatPasswordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "******"
        tf.isSecureTextEntry = true
        tf.textColor = UIColor.gray
        tf.addTarget(self, action: #selector(handleSignUpInformationChanged), for: .editingChanged)
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.mainGray()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.4
        button.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        setupInputViews()
    }
    
    @objc private func handleSignUpInformationChanged() {
    }
    
    @objc private func handleSignUpButton() {
        loginController?.finishSignUp()
    }
    
    private func setupInputViews() {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, repeatPasswordField, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 24
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(50, after: repeatPasswordField)
        } else {
            // Fallback on earlier versions
        }
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 230)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        layoutIfNeeded()
        loginTextField.addBottomBorder(color: UIColor.mainGray(), width: 1)
        passwordTextField.addBottomBorder(color: UIColor.mainGray(), width: 1)
        repeatPasswordField.addBottomBorder(color: UIColor.mainGray(), width: 1)
    }
    
}

