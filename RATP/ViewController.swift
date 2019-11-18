//
//  ViewController.swift
//  RATP
//
//  Created by jpo on 18/11/2019.
//  Copyright © 2019 jpo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func onLogin(_ sender: Any) {
        if let _ = emailTextField.text, let _ = passwordTextField.text {
            if (emailTextField.text == "admin" && emailTextField.text == passwordTextField.text) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
                
                // Other method :
                // Drag from first controller to other, select show and set an identifier
                // self.performSegue(withIdentifier: IDENTIFIER, sender: self)
            }else {
                let alertController = UIAlertController(title: "Authentication falied", message: "Unable to login, please check your email/password.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

