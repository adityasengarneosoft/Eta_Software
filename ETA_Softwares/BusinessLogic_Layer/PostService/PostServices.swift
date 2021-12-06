

import Foundation

protocol IPostServices {
    
    func getProductListing(completionHandler: @escaping(Result<[PostList],APIError>)->())
    func getProductUserListing(id:Int,completionHandler: @escaping(Result<UserList,APIError>)->())
    
    func getProductPostDetailsListing(id:Int,completionHandler: @escaping(Result<PostDetails,APIError>)->())

    
}


import Foundation

struct PostServices: IPostServices {
    
    
    
    
    private var networkManager:INetworkManager?
    /*
     * Method name: init
     * Description: use init product service
     * Parameters: networkManager
     * Return:  -
     */
    init(networkManager:INetworkManager?) {
        self.networkManager = networkManager
    }
    /*
     * Method name: getProductListing
     * Description: use get product data from server
     * Parameters: param and completion handler
     * Return:  -
     */
    func getProductListing(completionHandler: @escaping(Result<[PostList], APIError>)->()) {
        networkManager?.performRequest(serviceType: .postProduct, completionHandler: completionHandler)
    }
    func getProductUserListing(id: Int, completionHandler: @escaping (Result<UserList, APIError>) -> ()) {
        
        networkManager?.performRequest(serviceType: .postUser(id: id), completionHandler: completionHandler)
        
        
    }
    func getProductPostDetailsListing(id: Int, completionHandler: @escaping (Result<PostDetails, APIError>) -> ()) {
        networkManager?.performRequest(serviceType: .postDetails(id: id), completionHandler: completionHandler)

    }
}
