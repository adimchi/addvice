//
//  LoginViewController.swift
//  adviceApp
//
//  Created by Tameika Lawrence on 12/12/16.
//  Copyright © 2016 flatiron. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBtn.layer.borderWidth = 0
        registerBtn.clipsToBounds = true
        registerBtn.layer.cornerRadius = registerBtn.bounds.height * 0.5
        registerBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        skipBtn.layer.borderWidth = 0
        skipBtn.clipsToBounds = true
        skipBtn.layer.cornerRadius = registerBtn.bounds.height * 0.5
        skipBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameField.center.x -= view.bounds.width
        passwordField.center.x -= view.bounds.width
        registerBtn.center.y += view.bounds.width * 2.0
        skipBtn.center.y += view.bounds.width * 2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.50),
                       initialSpringVelocity: CGFloat(1.0),
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        self.usernameField.center.x += self.view.bounds.width
        },
                       completion: { Void in()  }
        )


        UIView.animate(withDuration: 0.6,
                       delay: 0.1,
                       usingSpringWithDamping: CGFloat(0.50),
                       initialSpringVelocity: CGFloat(1.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.passwordField.center.x += self.view.bounds.width
        },
                       completion: { Void in()  }
        )
        
        
        UIView.animate(withDuration: 0.8,
                       delay: 0.1,
                       options: .curveEaseInOut,
                       animations:  {
                        self.registerBtn.center.y -= self.view.center.y * 2.3
        },
                       completion: { Void in()
        })
        
        UIView.animate(withDuration: 0.8,
                       delay: 0.2,
                       options: .curveEaseInOut,
                       animations: {
                        self.skipBtn.center.y -= self.view.center.y * 2.35
        },
                       completion: { Void in()
            
        })
    }
    
    
    
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        guard let username = usernameField.text else { return }
        guard let password = passwordField.text else { return }
        
        FIRAuth.auth()?.createUser(withEmail: username, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                //message of success
            }else{
                //message of failure
            
            }
        })
        
        
    }
    
    
    
    // TODO: if user clicks skip button disable tvc for save advice
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
