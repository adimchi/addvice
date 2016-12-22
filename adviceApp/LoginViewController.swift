//
//  LoginViewController.swift
//  adviceApp
//
//  Created by Tameika Lawrence on 12/20/16.
//  Copyright © 2016 flatiron. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        guard let username = usernameField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (FIRUser, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("🔥successfully logged in")
                //self.performSegue(withIdentifier: "showAdviceHome", sender: self)
            }
            
        })
    }
    
    
    
    
    // TODO: IF SKIP BUTTON IS PRESSED DISABLE SAVED ADVICE TVC
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
