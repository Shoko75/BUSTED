//
//  ResetPasswordViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-15.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//
import Firebase

class ResetPasswordViewModel {
    
    func resetPassword(email: String, onSuccuss: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccuss()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
}
