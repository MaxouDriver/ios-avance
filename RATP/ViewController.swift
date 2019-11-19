//
//  ViewController.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBAction func onLogin(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {

            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                if (error == nil) {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
                    self?.present(homeViewController, animated: true, completion: nil)
                    
                    // Other method :
                    // Drag from first controller to other, select show and set an identifier
                    // self.performSegue(withIdentifier: IDENTIFIER, sender: self)
                }else {
                    
                    let alertController = UIAlertController(title: "Authentication falied", message: "Unable to login, please check your email/password.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ boolean: Bool) {
        super.viewWillAppear(boolean)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }

    
    override func viewWillDisappear(_ boolean: Bool) {
        super.viewWillDisappear(boolean)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}

