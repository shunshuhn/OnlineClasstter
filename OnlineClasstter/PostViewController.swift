//
//  PostViewController.swift
//  OnlineClasstter
//
//  Created by 伊藤　陽香 on 2020/10/04.
//  Copyright © 2020 伊藤　陽香. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostViewController: UIViewController {
    @IBOutlet weak var contentTextField: UITextField! {
        didSet {
            contentTextField.delegate = self
        }
    }

    let auth = Auth.auth()
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentTextField.resignFirstResponder()
    }

    @IBAction func tappedPostButton() {
        guard let content = contentTextField.text, !content.isEmpty else {
            let alertController = UIAlertController(title: "内容を入力してください", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        let post = Post(userName: auth.currentUser?.displayName ?? "不明なユーザー", content: content, createdAt: Date())

        _ = try? db.collection("posts").addDocument(from: post) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                let alertController = UIAlertController(title: "投稿エラー", message: "\(error)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

