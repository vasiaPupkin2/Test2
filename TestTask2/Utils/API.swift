//
//  API.swift
//  TestTask2
//
//  Created by leanid niadzelin on 19.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {
    
    private let baseURL = "http://213.184.248.43:9099/"
    
    static let shared = API()
    
    
    // Authorization
    
    func logingIn(login: String, password: String, completion: @escaping (Bool, JSON?, String?) -> ()) {
        
        let parameters: Parameters = ["login" : login, "password" : password]
        
        Alamofire.request(baseURL + "/api/account/signin", method: .post, parameters: parameters, encoding:JSONEncoding.default).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if status == 200 {
                if let data = data {
                    let json = JSON(data: data)
                    completion(true, json, nil)
                } else {
                    completion(true, nil, nil)
                }
            } else {
                if let data = data {
                    let json = JSON(data: data)
                    print(json)
                    let errors = json["valid"].arrayValue
                    var message = String()
                    for error in errors{
                        message += error["field"].stringValue + " : " + error["message"].stringValue + "\n"
                    }
                    if message != ""{
                        completion(false, json, message)
                    } else {
                        completion(false, nil, "Wrong login or password")
                    }
                    
                }
                completion(false, nil, "Error")
            }
        }
    }
    
    func signUp(login: String, password: String, completion: @escaping (Bool, JSON?, String?) -> ()) {
        
        let parameters: Parameters = ["login" : login, "password" : password]
        
        Alamofire.request(baseURL + "/api/account/signup", method:.post, parameters: parameters, encoding:JSONEncoding.default).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if status == 200 {
                if let data = data {
                    let json = JSON(data: data)
                    completion(true, json, nil)
                } else {
                    completion(true, nil, nil)
                }
            } else {
                if let data = data {
                    let json = JSON(data: data)
                    let errors = json["valid"].arrayValue
                    var message = String()
                    for error in errors{
                        message += error["field"].stringValue + " : " + error["message"].stringValue + "\n"
                    }
                    if message != ""{
                        completion(false, json, message)
                    } else {
                        completion(false, nil, "Error")
                    }
                }
                completion(false, nil, "Error")
            }
        }
    }
    
    // Photo
    
    func postPhoto(imageData: String, date: Int, latitude: Double, longitude: Double, completion: @escaping (Bool, JSON?, String?) -> ()) {
        
        let token = UserDefaults.standard.value(forKey: "token") as? String
        let params: Parameters = ["base64Image" : imageData, "date" : date, "lat" : latitude, "lng" : longitude]
        let headers: HTTPHeaders = [ "Accept": "application/json;charset=UTF-8", "Access-Token": token!]
        
        Alamofire.request(baseURL + "/api/image", method:.post, parameters: params, encoding:JSONEncoding.default, headers : headers).response {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if status == 200 {
                if let data = data {
                    let json = JSON(data: data)
                    completion(true, json, nil)
                } else {
                    completion(true, nil, nil)
                }
            } else {
                if let data = data {
                    let json = JSON(data: data)
                    let message = json["message"].string
                    completion(false, json, message)
                }
                completion(false, nil, nil)
            }
        }
    }
    
    
    func removePhoto(itemId: Int, completion: @escaping (Bool, JSON?, String?) -> ()) {
        
        let token = UserDefaults.standard.value(forKey: "token") as? String
        
        Alamofire.request(baseURL + "/api/image/\(itemId)", method: .delete, parameters: ["id": itemId], encoding: JSONEncoding.default, headers: ["Access-Token": token!]).responseJSON {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if status == 200 {
                if let data = data {
                    let json = JSON(data: data)
                    completion(true, json, nil)
                } else {
                    completion(true, nil, nil)
                }
            } else {
                if status == 500 {
                    completion(true, nil, "removePhotoError")
                } else {
                    if let data = data {
                        let json = JSON(data: data)
                        let message = json["message"].string
                        completion(false, json, message)
                    }
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    // Comments
    
    func postComment(imageId: Int, date: Int, text: String, completion: @escaping (Bool, JSON?, String?) -> ()) {
        
        let token = UserDefaults.standard.value(forKey: "token") as? String
        let params: Parameters = [ "text" : text, "date" : date]
        let headers: HTTPHeaders = [ "Access-Token": token!]
        
        Alamofire.request(baseURL + "/api/image/\(imageId)/comment", method:.post, parameters: params, encoding:JSONEncoding.default, headers : headers).responseJSON {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if status == 200 {
                if let data = data {
                    let json = JSON(data: data)
                    completion(true, json, nil)
                } else {
                    completion(true, nil, nil)
                }
            } else {
                if let data = data {
                    let json = JSON(data: data)
                    let message = json["message"].string
                    completion(false, json, message)
                }
                completion(false, nil, nil)
            }
        }
    }
    
    func removeComment(commentId: Int, imageId: Int, completion: @escaping (Bool, JSON?, String?) -> ()) {
        
        let token = UserDefaults.standard.value(forKey: "token") as? String
        
        let params: Parameters = ["imageId" : imageId, "commentId" : commentId]
        
        
        Alamofire.request(baseURL + "/api/image/\(imageId)/comment/\(commentId)", method: .delete, parameters: params, encoding: JSONEncoding.default, headers: ["Access-Token": token!]).responseJSON {
            response in
            let status = response.response?.statusCode
            let data = response.data
            if status == 200 {
                if let data = data {
                    let json = JSON(data: data)
                    completion(true, json, nil)
                } else {
                    completion(true, nil, nil)
                }
            } else {
                if let data = data {
                    let json = JSON(data: data)
                    let message = json["message"].string
                    completion(false, json, message)
                }
                completion(false, nil, nil)
            }
        }
    }
    
}


