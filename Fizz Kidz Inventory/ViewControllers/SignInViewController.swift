//
//  SplashScreenViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 16/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleSignIn

/// Pre-load item information from Firestore and store as global variables
class SignInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()

        // hide sign in button and start activity indicator
        self.signInButton.isHidden = true
        self.activityIndicator.startAnimating()
    }
    
    /// shows the sign in button
    func showSignInButton() {
        // UI changes to be dispatched to main thread
        DispatchQueue.main.async {
            self.signInButton.isHidden = false
        }
    }
    
    func hideSignInButton() {
        // UI changes to be dispatched to main thread
        DispatchQueue.main.async {
            self.signInButton.isHidden = true
        }
    }
    
    /// called when user has signed into Google Sign In - begin Firestore pr-efetch
    func userAuthenticated() {
        // UI changes to be dispatched to main thread
        DispatchQueue.main.async {
            self.signInButton.isHidden = true
            self.fetchFirestoreData()
        }
    }
    
    /// fetches item codes and display names from firestore and stores into global structs
    func fetchFirestoreData() {
        
        let firestore: Firestore = Firestore.firestore()
        let location = "WAREHOUSE" // all location items match, can use any
        
        firestore.collection(location).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("SPLASH SCREEN FETCH ERROR: \(error)")
            } else {
                for item in querySnapshot!.documents {
                    Items.item_names[item.documentID] = item.data()["DISP_NAME"] as? String
                    Items.item_units[item.documentID] = item.data()["UNIT"] as? String
                }
                
                // move on to main screen
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
        }
    }
}

/// Protocol for any views which can log out of Google Sign-In
protocol LogOutProtocol {}

// default implementations
extension LogOutProtocol {
    /// logs out of Google Sign In, and returns to the login page
    func logOut() {
        GIDSignIn.sharedInstance()?.signOut()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootController = storyboard.instantiateViewController(withIdentifier: "signInViewController")
        appDel.window?.rootViewController = rootController
    }
}
