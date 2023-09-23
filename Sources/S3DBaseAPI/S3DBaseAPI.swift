import Moya
import Foundation
import S3DCoreModels

public class BaseAPI {
    public var session:SessionItem?
    public var provider = MoyaProvider<S3DAPI>(plugins: [
        StatusCodeInterceptorPlugin()
    ])
    public init(mocking:Bool=false){
        guard mocking else { return }
            
        let endpointClosure = { (target: S3DAPI) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        self.provider =  MoyaProvider<S3DAPI>(endpointClosure: endpointClosure,
            plugins: [
            StatusCodeInterceptorPlugin()])
            
    }
    public init(provider: MoyaProvider<S3DAPI> = MoyaProvider<S3DAPI>()) {
        self.provider = provider
    }
    
    public func requestCode(phoneNumber:String) async -> Bool?{
        await provider.asyncRequest(type: APIResult<Bool>.self, .requestCode(phoneNumber: phoneNumber))?.result
    }
    
    public func validateCode(phoneNumber:String, code:String) async -> SessionItem?{
        guard let jwtToken = await provider.asyncRequest(type: APIResult<String>.self, .validateCode(phoneNumber: phoneNumber, code:code))?.result else {
            return nil
        }
        return SessionItem(token: jwtToken)
    }
}
