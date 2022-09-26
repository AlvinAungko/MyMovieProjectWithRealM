//
//  RegisterCredentials.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation

struct RegisterCredentials:Codable
{
    let name:String?
    let email:String?
    let phone:String?
    let password:String?
    let facebookToken:String?
    let googleToken:String?
    
    enum CodingKeys:String,CodingKey
    {
        case name,email,phone,password
        case facebookToken = "facebook-access-token"
        case googleToken = "google-access-token"
    }

}

// FaceBook_Token === 1212
// Google_Token === 78987
