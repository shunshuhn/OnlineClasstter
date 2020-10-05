//
//  ViewController.swift
//  OnlineClasstter
//
//  Created by 伊藤　陽香 on 2020/10/04.
//  Copyright © 2020 伊藤　陽香. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            tableView.dataSource = self
        }
    }

    var handler: AuthStateDidChangeListenerHandle!
    var posts: [Post] = []

    let auth = Auth.auth()
    let db = Firestore.firestore()
    private let cellIdentifier = "cell"
    private let loginSegueIdentifier = "toLogin"
    private let postSegueIdentifier = "toPost"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        handler = auth.addStateDidChangeListener { [weak self] auth, _ in
            guard let self = self else { return }
            if auth.currentUser == nil {
                self.performSegue(withIdentifier: self.loginSegueIdentifier, sender: nil)
            } else {
                print("Add Snapshot Listener")
                db.collection("posts").order(by: "createdAt", descending: true).addSnapshotListener { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        let alertController = UIAlertController(title: "エラー", message: error?.localizedDescription ?? "不明なエラー", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }

                    self.posts = documents.compactMap { try? $0.data(as: Post.self) }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        auth.removeStateDidChangeListener(handler)
    }

    @IBAction func tappedPostButton(_ sender: Any) {
        performSegue(withIdentifier: postSegueIdentifier, sender: nil)
    }

    @IBAction func tappedLogoutButton(_ sender: Any) {
        try? auth.signOut()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostTableViewCell
        cell.setValue(posts[indexPath.row])
        return cell
    }
}


