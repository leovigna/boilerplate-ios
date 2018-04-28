//
//  LVUser.swift
//  boilerplate-ios
//
//  Created by Leo Vigna on 24/10/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

///User class
class LVUser:LVObj {
    var email: String?
    var username: String?
    
    required init() {
        super.init();
    }
    
    required init(withId id:String) {
        super.init(withId: id);
    }
    
    ///Initialize using dictionary data
    required init(dataDict:Dictionary<String,Any>) {
        super.init(dataDict: dataDict);
        self.email = dataDict["email"] as? String;
        self.username = dataDict["username"] as? String;
    }
    
    override func reference() -> DocumentReference {
        return Firestore.firestore().collection("LVUser").document(id);
    }
    
    ///Set User Data
    override func setData(dataDict:Dictionary<String,Any>) {
        super.setData(dataDict: dataDict)
        self.email = dataDict["email"] as? String;
        self.username = dataDict["username"] as? String;
    }
    
    ///Return Dictionary representation of User
    override func toDictionary()-> Dictionary<String,Any> {
        var user = super.toDictionary()
        user["email"] = self.email;
        user["username"] = self.username;
        
        return user;
    }
    
}
