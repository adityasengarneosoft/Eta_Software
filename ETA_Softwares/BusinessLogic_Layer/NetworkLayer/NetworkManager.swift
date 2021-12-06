
import Foundation
import Alamofire

protocol INetworkManager {
    
    func performRequest<T: Codable>(serviceType:NetworkAPI, completionHandler: @escaping(Result<T,APIError>)->())
    //func performRequestGet<T: Codable>(id:Int,serviceType:NetworkAPI, completionHandler: @escaping(Result<T,APIError>)->())
    
}


final class NetworkManager:INetworkManager {
    
    public init() {}
    public let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.timeoutIntervalForResource = TimeInterval(60)
        return Session(
            configuration: configuration)
    }()
    /*
     * Method name: performRequest
     * Description: use call api
     * Parameters: NetworkAPI and completion handler
     * Return:  -
     */
    func performRequest<T: Codable>(serviceType:NetworkAPI, completionHandler: @escaping(Result<T,APIError>)->()) {
        if NetworkReachabilityManager()?.isReachable == true {
            manager.request(serviceType.path,
                            method: serviceType.method,
                            parameters: serviceType.parameters,
                            encoding: serviceType.encoding,
                            headers: serviceType.headers).responseData { (response) in
                switch response.result {
                case .success(let value):
                    do {
                        
                        let model = try JSONDecoder().decode(T.self, from: value )
                        completionHandler(.success(model))
                    } catch let error {
                        debugPrint(error.localizedDescription)
                        completionHandler(.failure(.customError(message: error.localizedDescription)))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(.failure(.customError(message: error.localizedDescription)))
                }
            }
        } else {
            completionHandler(.failure(.NOInternet))
        }
    }
    func performRequestGet<T>(id: Int, serviceType: NetworkAPI, completionHandler: @escaping (Result<T, APIError>) -> ()) where T : Decodable, T : Encodable {
        if NetworkReachabilityManager()?.isReachable == true {
            manager.request("https://jsonplaceholder.typicode.com/users/" + String(id),
                            method: serviceType.method,
                            parameters: nil,
                            encoding: serviceType.encoding,
                            headers: serviceType.headers).responseData { (response) in
                switch response.result {
                case .success(let value):
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: value, options: [])
                        print(json)
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                    do {
                        
                        let model = try JSONDecoder().decode(T.self, from: value )
                        completionHandler(.success(model))
                    } catch let error {
                        debugPrint(error.localizedDescription)
                        completionHandler(.failure(.customError(message: error.localizedDescription)))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(.failure(.customError(message: error.localizedDescription)))
                }
            }
        } else {
            completionHandler(.failure(.NOInternet))
        }
    }
    
}
