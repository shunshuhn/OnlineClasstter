//
//  Post.swift
//  OnlineClasstter
//
//  Created by 伊藤　陽香 on 2020/10/05.
//  Copyright © 2020 伊藤　陽香. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Codable {
    @DocumentID var id: String?
    var userName: String
    var content: String
    var createdAt: Date
}

