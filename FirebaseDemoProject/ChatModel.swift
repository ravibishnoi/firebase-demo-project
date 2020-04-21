//
//  ChatModel.swift
//  Firebase Chat App
//
//  Created by AshutoshD on 06/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import Foundation
import UIKit

class ChatModel {
    var userID : String
    var firstName : String
    var lastName : String
    var profileUrl : String
    init(userID : String , firstName : String ,  lastName : String, profileUrl : String ) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.profileUrl = profileUrl
    }
}
