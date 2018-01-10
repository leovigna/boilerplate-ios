//
//  LVPayVC.swift
//  boilerplate
//
//  Created by Leo Vigna on 26/12/2017.
//  Copyright © 2017 Leo Vigna. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class LVPayVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    var latestCustomerId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        print(#function)
        let email = emailField.text!
        
        LVStripe.signupAccount(email: email).then { res -> Void in
            print("Sucess.")
            self.latestCustomerId = res["stripeId"] as! String;
            }.catch { err in print(err.localizedDescription) }
    }
    
    @IBAction func didTapCard(_ sender: Any) {
        print(#function)
        showAddCard()
    }
    
    @IBAction func didTapPay(_ sender: Any) {
        print(#function)
        LVStripe.addCharge(stripeId: latestCustomerId, amount: 500)
            .then { res -> Void in
                print("Sucess.")
            }.catch { err in print(err.localizedDescription) }
    }
}

extension LVPayVC:STPAddCardViewControllerDelegate {
    func showAddCard() {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func saveCard(token: STPToken) {
        LVStripe.addCard(stripeId: latestCustomerId, token: token).then { res -> Void in
            self.dismiss(animated: true)
            }
            .catch { err in print(err.localizedDescription) }
    }
    
    // MARK: STPAddCardViewControllerDelegate
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print(#function)
        print("didCreateToken: \(token)")
        saveCard(token: token)
        completion(nil)
        
    }
}
