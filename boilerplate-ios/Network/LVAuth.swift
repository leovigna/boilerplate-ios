//
//  LVAuth.swift
//  boilerplate-ios
//
//  Created by Leo Vigna on 24/10/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

///Manage user authentification with Firebase.
class LVAuth {
    static var currentUser: User? {
        get {
            return Auth.auth().currentUser;
        }
    }
    
    /**
     Creates an Auth account with email and password.
     - parameter email: Account email.
     - parameter pass: Account password.
     - returns: Promise with user id.
     */
    static func create(email:String,pass:String) -> Promise<String> {
        return Promise { fulfill, reject in
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if (error == nil) {
                    let uid = user?.uid
                    fulfill(uid!)
                }
                else { print(error ?? "No error"); reject(error!) }
            }
        }
    }
    
    /**
     Attempts login with email and password.
     - parameter email: Account email.
     - parameter pass: Account password.
     - returns: Promise with user id.
     */
    static func login(email:String,pass:String) -> Promise<String> {
        return Promise { fulfill, reject in
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if (error == nil) {
                    let uid = user?.uid
                    fulfill(uid!)
                }
                else { print(error ?? "No error"); reject(error!) }
            }
        }
    }
    
    /**
     Sends password reset email.
     - parameter email: Account email.
     - returns: Promise with success boolean.
     */
    static func resetPass(email:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if (error == nil) {
                    fulfill(true)
                }
                else { print(error ?? "No error"); reject(error!) }
            }
        }
    }
    
    /**
     Logs out user.
     */
    static func logout() -> Promise<Bool> {
        return Promise { fulfill, reject in
            do{
                try Auth.auth().signOut()
                fulfill(true)
            }catch{
                print("Error while signing out!")
                reject("Error while signing out!")
            }
        }
    }
    
    /**
     Changes user email.
     - parameter email: Account email.
     - parameter pass: Account password.
     - parameter newEmail: Account **new** email.
     - returns: Promise with success boolean.
     */
    static func changeEmail(email:String,pass:String,newEmail:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            let currentUser = Auth.auth().currentUser
            
            currentUser?.reauthenticate(with: credential, completion: { (err) in
                if (err == nil) {
                    currentUser?.updateEmail(to: newEmail) { (error) in
                        if (error == nil) {
                            fulfill(true)
                        }
                        else { print(error ?? "No error"); reject(error!) }
                    }
                    
                } else { print(err ?? "No error"); reject(err!) }
            })
            
        }
    }
    
    /**
     Changes user password.
     - parameter email: Account email.
     - parameter pass: Account password.
     - parameter newPass: Account **new** password.
     - returns: Promise with success boolean.
     */
    static func changePass(email:String,pass:String,newPass:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            let currentUser = Auth.auth().currentUser
            
            currentUser?.reauthenticate(with: credential, completion: { (err) in
                if (err == nil) {
                    currentUser?.updatePassword(to: newPass) { (error) in
                        if (error == nil) {
                            fulfill(true)
                        }
                        else { print(error ?? "No error"); reject(error!) }
                    }
                    
                } else { print(err ?? "No error"); reject(err!) }
            })
        }
    }
    
    /**
     Deletes user account.
     - parameter email: Account email.
     - parameter pass: Account password.
     - returns: Promise with success boolean.
     */
    static func deleteAccount(email:String,pass:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
            let currentUser = Auth.auth().currentUser
            
            currentUser?.reauthenticate(with: credential, completion: { (err) in
                if (err == nil) {
                    currentUser?.delete() { (error) in
                        if (error == nil) {
                            fulfill(true)
                        }
                        else { print(error ?? "No error"); reject(error!) }
                    }
                    
                } else { print(err ?? "No error"); reject(err!) }
            })
        }
    }
}
