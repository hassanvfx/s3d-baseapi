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
        self.provider =  MoyaProvider<S3DAPI>(stubClosure: MoyaProvider.delayedStub(2), plugins: [
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
