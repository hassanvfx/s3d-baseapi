//
//  APICoordinator.swift
//  TwinChatAI
//
//  Created by Eon Fluxor on 2/16/23.
//

import Foundation
import Combine
import Moya
import CombineMoya

public struct APIResult<ITEM:Codable>:Codable{
    public var result:ITEM?
}

public extension Notification.Name {
    static let S3DBaseAPIInvalidSession = NSNotification.Name("s3d.baseapi.invalidSessionError.code401")
}

public final class StatusCodeInterceptorPlugin: PluginType {
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if case let .failure( error) = result {
            if let response = error.response, response.statusCode == 401 {
                // Handle the 401 error here
                NotificationCenter.default.post(name: .S3DBaseAPIInvalidSession, object: error)
            }
        }
    }
}

extension MoyaProvider{
    public func asyncRequest<T: Codable>(type: T.Type, retryCount: Int = 5, retryDelay: TimeInterval = 1.0,_ target: Target) async -> T? {
        do{
            return try await withCheckedThrowingContinuation { continuation in
                request(type: type, retryCount:retryCount, retryDelay:retryDelay, target) { result in
                    continuation.resume(with: result)
                }
            }
        }catch{
            let errorMessage = "error in async api response:\n \(error.localizedDescription)"
            print(errorMessage)
            return nil
        }
    }
}



extension MoyaProvider {
    public func request<T: Codable>(type: T.Type, retryCount: Int = 5, retryDelay: TimeInterval = 3.0,_ target: Target , completion: @escaping (Result<T?, MoyaError>) -> Void) {
        var remainingRetryCount = retryCount
        func requestWithRetry() {
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .iso8601
                        let decoded = try decoder.decode(T.self, from: response.data)
                        completion(.success(decoded))
                    } catch {
                        print("jsonString=\(try? response.mapJSON())")
                        let errorMessage = "invalid codec: \(error.localizedDescription)"
                        assertionFailure(errorMessage)
                        completion(.failure(MoyaError.jsonMapping(response)))
                    }
                case .failure(let error):
                    print("remainingRetryCount:\(remainingRetryCount)")
                    if remainingRetryCount > 0 {
                        remainingRetryCount -= 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                            guard let response = error.response,
                                  response.statusCode != 401 else{
                                completion(.failure(error))
                                return
                            }
                            requestWithRetry()
                        }
                    } else {
                        completion(.failure(error))
                    }
                }
            }
        }
        requestWithRetry()
    }
}
