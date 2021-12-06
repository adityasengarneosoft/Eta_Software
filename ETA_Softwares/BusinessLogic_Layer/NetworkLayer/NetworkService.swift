

import Foundation
import Alamofire

enum NetworkAPI {
    
    enum NetworkEnvironment: String {
        case Development
        case Production
        case QA
    }
    
    /*
     use to get network Environment
     */
    var networkEnvironment: NetworkEnvironment {
        return .Development
    }
    
    /*
     use to get base of the service
     */
    var BaseURL: String {
        switch networkEnvironment {
        case .QA:
            return ""
        case .Production:
            return ""
        default:
            return "http://jsonplaceholder.typicode.com/"
        }
    }
    
    case postProduct
    case postUser(id:Int)
    case postDetails(id:Int)
}

extension NetworkAPI {
    /*
     use to get path of the service
     */
    var path: String  {
        var servicePath = ""
        switch self {
        case .postProduct:
            servicePath = "posts"
        case .postUser(let id):
            servicePath = "users/" + String(id)
        case .postDetails(let id):
            servicePath = "posts/" + String(id)
            
        }
        return BaseURL + servicePath
    }
    /*
     use to get headers of the service
     */
    var headers: HTTPHeaders? {
        var headersDict = HTTPHeaders()
        headersDict["accept"] = "application/json"
        return headersDict
    }
    
    /*
     use to get parammeter of the service
     */
    var parameters:AnyDict? {
        let allParam : AnyDict = [ : ]
        switch self {
        case .postProduct,
                .postUser,
                .postDetails:
            return nil
        }
        return allParam
    }
    
    /*
     use to get method of the service
     */
    var method:HTTPMethod {
        switch self {
        case .postProduct,
                .postUser,
                .postDetails:
            
            return .get
        default:
            return .post
        }
    }
    /*
     use to get encoding of the service
     */
    var encoding:ParameterEncoding {
        switch self {
        case .postProduct,
                .postUser,
                .postDetails:
            
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
}

