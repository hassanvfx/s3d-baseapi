//
//  File.swift
//
//
//  Created by Eon Fluxor on 9/22/23.
//

import Moya
import Foundation

public enum S3DAPI {
    case requestCode(phoneNumber:String)
    case validateCode(phoneNumber:String, code:String )
 
}


// MARK: - TargetType Protocol Implementation
extension S3DAPI: TargetType {
    public var baseURL: URL { URL(string: "https://api.myservice.com")! }
    public var sampleData: Data{
        switch self {
        case .requestCode:
            return "true".utf8EncodedData
        case .validateCode:
            return "jwttoken12345abcd".utf8EncodedData
        }
    }
    public var path: String {
        switch self {
        case .requestCode:
            return "/requestCode"
        case .validateCode:
            return "/validateCode"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .requestCode,
                .validateCode:
            return .get
        }
    }
    public var task: Task {
        switch self {
        case let .requestCode(phoneNumber: phoneNumber):
            return .requestParameters(parameters: ["phoneNumber": phoneNumber], encoding: URLEncoding.queryString)
        case let .validateCode(phoneNumber: phoneNumber, code: code):
            return .requestParameters(parameters: ["phoneNumber": phoneNumber,"code":code], encoding: URLEncoding.queryString)
        }
    }
   
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
