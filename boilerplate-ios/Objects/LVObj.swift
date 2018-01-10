//
//  LVObj.swift
//  boilerplate
//
//  Created by Leo Vigna on 19/12/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

///LVObjProtocol
protocol LVObjProtocol {
    var id: String { get set }
    func reference() -> DocumentReference;
    
    func setData(dataDict:Dictionary<String,Any>);
    func toDictionary()-> Dictionary<String,Any>;
    func refresh() -> Promise<Bool>;
    func save(overwrite: Bool) -> Promise<Bool>;
    func delete() -> Promise<Bool>;
    
}

///LVObj
class LVObj: LVObjProtocol {
    var id: String;
    
    required init() {
        self.id = Firestore.firestore().collection("LVObj").document().documentID;
    }
    
    required init(withId id:String) {
        self.id = id;
    }
    
    ///Initialize using dictionary data
    required init(dataDict:Dictionary<String,Any>) {
        self.id = dataDict["id"] as! String;
    }
    
    ///Get collection reference
    func reference() -> DocumentReference {
        return Firestore.firestore().collection("LVObj").document(id);
    }
    
    ///Set Object Data
    func setData(dataDict:Dictionary<String,Any>) {
        self.id = dataDict["id"] as? String ?? self.id;
    }
    
    ///Return Dictionary representation of Object
    func toDictionary()-> Dictionary<String,Any> {
        var obj = Dictionary<String, Any>()
        obj["id"] = self.id;
        return obj;
    }
    
    ///Refresh with Firebase
    func refresh() -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            reference().getDocument { (document, error) in
                if let document = document {
                    print("Document data: \(document.data())")
                    self.setData(dataDict: document.data());
                    fulfill(true);
                } else {
                    print("Document does not exist")
                    reject(error!);
                }
            }
        }
    }
    
    ///Save to Firebase
    func save(overwrite: Bool = false) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let data = toDictionary();
            
            if (overwrite) {
                reference().setData(data) { error in
                    if let err = error {
                        print("Error writing document: \(err)");
                        reject(err);
                    } else {
                        print("Document successfully written!");
                        fulfill(true);
                    }
                }
            }
            else {
                reference().updateData(data) { error in
                    if let err = error {
                        print("Error writing document: \(err)");
                        reject(err);
                    } else {
                        print("Document successfully written!");
                        fulfill(true);
                    }
                }
            }
            
        }
    }
    
    ///Delete to Firebase
    func delete() -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            reference().delete() { error in
                if let err = error {
                    print("Error deleting document: \(err)");
                    reject(err);
                } else {
                    print("Document successfully deleted!");
                    fulfill(true);
                }
            }
        }
    }
    
}
