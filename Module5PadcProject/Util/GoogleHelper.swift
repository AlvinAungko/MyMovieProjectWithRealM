//
//  GoogleHelper.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 30/04/2022.
//

import Foundation
import GoogleSignIn
import UIKit

public class GoogleAuth : NSObject {
    
    private let OAUTH_ID_GOOGLE_SIGN_IN = "228521612703-dia60hv85n5u1qt79nqosofkii1rdvfi.apps.googleusercontent.com" // TODO: Add your key here
    
    public func start(
        view : UIViewController?,
        success: @escaping ((GoogleAuthProfileResponse) -> Void),
        failure: @escaping ((String) -> Void) ) {
        
        print("Google-Sign-In Authentication Started")
        
        guard let viewController = view else {
            failure("Referencing view controller is nil")
            return
        }
        
        let signInConfig = GIDConfiguration(clientID: OAUTH_ID_GOOGLE_SIGN_IN)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: viewController) {(user, error) in
//            guard let self = self else {
//                debugPrint("If nil, viewcontroller reference is already gone.")
//                return } /// If nil, viewcontroller reference is already gone.
          
            if let error = self.handleSignInError(error) {
                print("Google-Sign-In ended with error.")
                failure(error)
            }
            
            
            if let userData = self.handleUserData(user) {
                print("Google-Sign-In completed successfully.")
                success(userData)
            } else {
                failure("\(#function) Google-Sign-In returns no user information")
            }
        }
    
    }
    
    private func handleSignInError(_ error : Error?) -> String? {
        /// Handle Error
        if let error = error {
            let errorCode : Int = (error as NSError).code
            switch errorCode {
            case GIDSignInError.hasNoAuthInKeychain.rawValue:
                return "The user has not signed in before or they have since signed out."
            default:
                return "\(error.localizedDescription)"
            }
        }
        return nil
    }
    
    
    private func handleUserData(_ user : GIDGoogleUser?) -> GoogleAuthProfileResponse? {
        /// Handle User Information
        guard let user = user else {
            return nil
        }
        
        // Perform any operations on signed in user here.
        let userId = user.userID ?? "" // For client-side use only!
        let token = user.authentication.idToken ?? ""
        let fullName = user.profile?.name ?? ""
        let givenName = user.profile?.givenName ?? ""
        let familyName = user.profile?.familyName ?? ""
        let email = user.profile?.email ?? ""
        
        let userData = GoogleAuthProfileResponse(
            id: userId,
            token: token,
            fullname: fullName,
            giveName: givenName,
            familyName: familyName,
            email: email
        )
        
        return userData
    }
}

public struct GoogleAuthProfileResponse {
    public let id, token, fullname, giveName, familyName, email : String
}
