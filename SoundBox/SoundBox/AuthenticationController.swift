//
//  AuthenticationController.swift
//  SoundBox
//
//  Created by  User on 23.05.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
class AuthenticationController: UIViewController {
    
    
    @IBAction func onTapGoogleSignInButton(_ sender: Any) {
        handleSignInButton()
    }
    
    
    func handleSignInButton() {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self) { signInResult, error in
                guard let result = signInResult else {
                    // Inspect error
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    let controller=self.storyboard!.instantiateViewController(withIdentifier: "TabBar")
                    BaseController.idUser=(signInResult?.user.userID)!
                    //Replace rootView
                    UIApplication.shared.keyWindow?.rootViewController=controller
                }
                // If sign in succeeded, display the app's main content View.
            }
    }
    
}
