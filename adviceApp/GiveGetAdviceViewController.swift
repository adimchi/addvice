//
//  ViewController.swift
//  adviceApp
//
//  Created by Tameika Lawrence on 9/25/16.
//  Copyright © 2016 flatiron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import QuartzCore


class ViewController: UIViewController {
    
    // MARK: UI Properties
    
    @IBOutlet weak var giveAdviceTextField: UITextField!
    
    @IBOutlet weak var displayAdviceTextLabel: UILabel!
    
    @IBOutlet weak var getAdviceBtnOutlet: UIButton!
    
    @IBOutlet weak var savedAdviceBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var savedAdviceBtn: UIButton!
    
    @IBOutlet weak var giveAdviceBtnOutlet: UIButton! {
        
        didSet {
            
            giveAdviceBtnOutlet.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            UIView.animate(withDuration: 1.0,
                           delay: 0.5,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10.0,
                           options: .curveLinear,
                           animations: {
                            self.giveAdviceBtnOutlet.transform = CGAffineTransform.identity
                            print("successfully animated button")
            })
            
        }
    }

    
    @IBOutlet weak var logoutBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    
    var userHasSkippedLogin: Bool = false
    
    
    
    
    // MARK: Logic Properties
    
    let badWordsArray = BadWords.sharedInstance
    let store = DataStore.sharedInstance
    var badWordFlag = false
    var currentAdviceIndex: Int?
    var currentFIRAdviceIndex: Int?
    var savedAdvice = [Advice]()
    var displayedAdvice: Advice!
    var displayedFIRAdvice: String = ""
    var ref: FIRDatabaseReference!
    var firAdviceArray = [String]()
    
    //    @IBAction func logout(_ sender: Any) {
    //
    //        NotificationCenter.default.post(name: .closeAddviceVC, object: nil)
    //    }
    
    let seafoamGreen = UIColor(red:0.82, green:0.94, blue:0.87, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //connectToDatabase()
        
        if userHasSkippedLogin {
            print("🍻inside userHasSkipped if statement")
            disableSaveButton()
            
        }
        
        
        giveAdviceTextField.delegate = self
        self.giveAdviceBtnOutlet.layer.borderWidth = 2.0
        self.giveAdviceBtnOutlet.clipsToBounds = true
        self.giveAdviceBtnOutlet.layer.cornerRadius = giveAdviceBtnOutlet.bounds.height * 0.5
        self.giveAdviceBtnOutlet.layer.borderColor = seafoamGreen.cgColor
        self.giveAdviceBtnOutlet.backgroundColor = UIColor.clear
        
        
        self.getAdviceBtnOutlet.layer.borderWidth = 2.0
        self.getAdviceBtnOutlet.clipsToBounds = true
        self.getAdviceBtnOutlet.layer.cornerRadius = getAdviceBtnOutlet.bounds.height * 0.5
        self.getAdviceBtnOutlet.layer.borderColor = seafoamGreen.cgColor
        self.getAdviceBtnOutlet.backgroundColor = UIColor.clear
        
        self.savedAdviceBtn.layer.borderWidth = 2.0
        self.savedAdviceBtn.clipsToBounds = true
        self.savedAdviceBtn.layer.cornerRadius = savedAdviceBtn.bounds.height * 0.5
        self.savedAdviceBtn.layer.borderColor = seafoamGreen.cgColor
        self.savedAdviceBtn.backgroundColor = UIColor.clear
        
        self.displayAdviceTextLabel.clipsToBounds = true
        self.displayAdviceTextLabel.layer.cornerRadius = 5
        
        getAdviceBtnOutlet.isEnabled = false
        savedAdviceBtn.isEnabled = false
        giveAdviceBtnOutlet.isEnabled = false
        print(savedAdvice)
        store.fetchData()
        
        
        self.textField.borderStyle = .roundedRect
        self.textField.layer.borderColor = seafoamGreen.cgColor
        self.textField.layer.borderWidth = 2.0
        self.textField.textColor = seafoamGreen
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        
        
    }
    
//    func buttonAnimationTest() {
//        
//        UIView.animate(withDuration: 1.0,
//                       delay: 0.5,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 10.0,
//                       options: .curveLinear,
//                       animations: { 
//                        self.giveAdviceBtnOutlet.transform = CGAffineTransform.identity
//                        print("successfully animated button")
//        })
//        
//        
//    }
    
    
    
    
    //
    //    func buttonPressedAnimation() {
    //
    //        UIView.animateKeyframes(withDuration: 1.0,
    //                                delay: 0.0,
    //                                options: .calculationModeCubic,
    //                                animations: {
    //
    //            UIView.addKeyframe(withRelativeStartTime: 0.0,
    //                               relativeDuration: 0.3,
    //                               animations: {
    //
    //                self.giveAdviceBtnOutlet.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.75)
    //            })
    //
    //           UIView.addKeyframe(withRelativeStartTime: 0.5,
    //                              relativeDuration: 0.5,
    //                              animations: {
    //                self.giveAdviceBtnOutlet.transform = CGAffineTransform.init(scaleX: 1.0, y: 2.0)
    //           })
    //
    //        })
    //    }
    
    
    //    func connectToDatabase() {
    //
    //        let advice = giveAdviceTextField.text
    //        let ref = FIRDatabase.database().reference()
    //        ref.child("Advice").childByAutoId().setValue([advice])
    //
    //
    //
    //    }
    
    
    
    
    @IBAction func submitAdviceBtnPressed(_ sender: UIButton) {
        
        giveAdviceBtnOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 6 / 5))
        
        UIView.animate(withDuration: 0.2) {
            self.giveAdviceBtnOutlet.transform = CGAffineTransform.identity
        }
        
        
        guard !badWordFilter() else { return }
        
        guard let adviceReceived = giveAdviceTextField.text else { return }
        
        let newAdvice = Advice(context: store.persistentContainer.viewContext)
        
        newAdvice.content = adviceReceived
        
        store.adviceArray.append(newAdvice)
        
        giveAdviceTextField.text = ""
        
        getAdviceBtnOutlet.isEnabled = true
        
        giveAdviceBtnOutlet.isEnabled = false
        
        store.saveContext()
        
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("Advice").childByAutoId().setValue(["content": adviceReceived])
    }
    
    
    
    
    
    @IBAction func receiveAdviceBtnPressed(_ sender: UIButton) {
        
        //TODO: Receiving own advice. Fix that.
        
        savedAdviceBtn.isEnabled = true
        
        var content = String()
        
        //        var randomAdviceIndex = Int(arc4random_uniform(UInt32(store.adviceArray.count)))
        //
        //        if let currentAdviceIndex = currentAdviceIndex, store.adviceArray.count > 1 {
        //
        //            while randomAdviceIndex == currentAdviceIndex {
        //
        //                randomAdviceIndex = Int(arc4random_uniform(UInt32(store.adviceArray.count)))
        //            }
        //        }
        //
        //        currentAdviceIndex = randomAdviceIndex
        //
        //        displayedAdvice = store.adviceArray[randomAdviceIndex]
        //
        //        displayAdviceTextLabel.text = displayedAdvice.content
        
        
        let ref = FIRDatabase.database().reference()
        
        let receivedRef = ref.child("Advice")
        
        receivedRef.observeSingleEvent(of: .value, with: { snapshot in
            
                                                //[uids : any]
            if let firAdvice = snapshot.value as? [String : Any] {
                
                
                for each in firAdvice {
                    
                    self.firAdviceArray.append(String(describing: each.value["content"]))
                }
                
                print(self.firAdviceArray)
                
                for advice in self.firAdviceArray {
                    
                    self.displayAdviceTextLabel.text = advice
                }
                
                
//                for (_, value) in firAdvice {
//                    
//                     var contentArray = [String]()
//
//                    if let contentsDictionary = value as? [String : String] {
//                        
//                        
//                         content = contentsDictionary["content"] ?? "NO CONTENT"
//                        
//                        
//                        contentArray.append(content)
//
//                            contentArray.append(content)
//
//                        print("\n🐔\(content)")
//                        print("\(contentArray)")
//                    }
//                }
                
                
         
                
                
                
                
                
                
                
                
                
                
//                // print("👙from FIREBASE \(firAdvice)")
//                
//                //guard let firAdviceString = firAdvice["content"] else { return }
//                
//                self.firAdviceArray.append(firAdviceString as! String)
//                
//                // print("👻 \(self.firAdviceArray)")
//                
//                
//                
//                var randomFIRAdviceIndex = Int(arc4random_uniform(UInt32(self.firAdviceArray.count)))
//                
//                
//                if let currentFIRAdviceIndex = self.currentFIRAdviceIndex, self.firAdviceArray.count > 1 {
//                    
//                    while randomFIRAdviceIndex == currentFIRAdviceIndex {
//                        
//                        randomFIRAdviceIndex = Int(arc4random_uniform(UInt32(self.firAdviceArray.count)))
//                        
//                    }
//                    
//                    self.currentFIRAdviceIndex = randomFIRAdviceIndex
//                    
//                    self.displayedFIRAdvice = self.firAdviceArray[randomFIRAdviceIndex]
//                    
//                    print("🐼 \(self.displayedFIRAdvice)")
//                    
//                    self.displayAdviceTextLabel.text = self.displayedFIRAdvice
//                }
//                
                
                
            }
            
        })
        
        
    }
    
    
    @IBAction func saveAdvicePressed(_ sender: Any) {
        
        //TODO: fix save!!!!
        
        if displayAdviceTextLabel.text != nil {
            
            displayedAdvice.isFavorited = true
            
            store.saveContext()
            
            // TODO: Let the user know that it was saved (display something to them)
            // TODO: Also, should we then immediately display a new piece of advice after we save one?
            
        }
        
    }
    
    
    func disableSaveButton() {
        print("🎈inside disable save button method")
        savedAdviceBarBtn.isEnabled = false
    }
    
    //    func disableLogoutButton() {
    //        logoutBarBtn.isEnabled = false
    //    }
    
    
    
    
    
    
    func badWordFilter() -> Bool {
        
        for word in badWordsArray.badWordsList {
            
            if let adviceText = giveAdviceTextField.text {
                
                if adviceText.contains(word) {
                    print(word)
                    
                    let alert = UIAlertController(title: "Wait A Fucking Minute", message: "You can't curse here.", preferredStyle: UIAlertControllerStyle.alert)
                    print("alert")
                    
                    let okAction = UIAlertAction(title: "OK Cool", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return true
                    
                } else {
                    
                    
                }
            }
            
        }
        
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "logoutIdentifier" {
            print("🍇 the current user is \(FIRAuth.auth()?.currentUser?.uid)")
            try! FIRAuth.auth()?.signOut()
            print("🎉Successfully logged out \(FIRAuth.auth()?.currentUser?.uid).")
            
        }else if segue.identifier == "showSavedAdvice" {
            print("going to showSavedAdvice")
        }
        
    }
    
    
    //end
    
}






// Todo: animate alert controller
// Todo: implement logout feature
// Todo: FLAG BAD ADVICE (1.1)




