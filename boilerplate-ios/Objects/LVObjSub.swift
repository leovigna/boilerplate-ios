//
//  LVObjSub.swift
//  boilerplate
//
//  Created by Leo Vigna on 19/12/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

///LVObjSub
class LVObjSub: LVObj {
    var field1: String?
    var score1: Int
    
    required init() {
        score1 = 0;
        super.init();
        
    }
    
    required init(withId id:String) {
        score1 = 0;
        super.init(withId: id);
    }
    
    required init(dataDict:Dictionary<String,Any>) {
        self.field1 = dataDict["field1"] as? String;
        self.score1 = dataDict["score1"] as! Int;
        super.init(dataDict: dataDict);
    }
    
    override func reference() -> DocumentReference {
        return Firestore.firestore().collection("LVObjSub").document(id);
    }
    
    override func setData(dataDict: Dictionary<String, Any>) {
        super.setData(dataDict: dataDict);
        self.field1 = dataDict["field1"] as? String;
    }
    
    override func toDictionary() -> Dictionary<String, Any> {
        var obj = super.toDictionary();
        obj["field1"] = field1;
        obj["score"] = score1;
        return obj;
    }
    
    func increment(value:Int) -> Promise<Int> {
        return Promise { fulfill, reject in
            Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
                let document: DocumentSnapshot;
                do {
                    try document = transaction.getDocument(self.reference())
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let score = document.data()["score"] as? Int else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to retrieve score from snapshot \(document)"
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }
                
                let newScore = score + value;
                transaction.updateData(["score": newScore], forDocument: self.reference());
                
                return newScore;
            }) { (newScore, error) in if let error = error {
                print("Transaction failed: \(error)");
                reject(error);
            } else {
                print("Transaction successfully committed!");
                self.score1 = newScore as! Int;
                fulfill(self.score1);
                }
            }
        }
    }
    
}
