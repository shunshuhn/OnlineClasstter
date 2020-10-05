//
//  LoginViewController.swift
//  OnlineClasstter
//
//  Created by 伊藤　陽香 on 2020/10/04.
//  Copyright © 2020 伊藤　陽香. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!

    let auth = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.presentationController?.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
    }

    @IBAction func tappedLoginButton() {
        guard let name = nameTextField.text, !name.isEmpty else {
            let alertController = UIAlertController(title: "名前を入力してください", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        auth.signInAnonymously { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                let alertController = UIAlertController(title: "ログインエラー", message: "\(error)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let changeRequest = result?.user.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { error in
                    if let error = error {
                        let alertController = UIAlertController(title: "ログインエラー", message: "\(error)", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }

            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// スワイプで閉じないようにする
extension LoginViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

