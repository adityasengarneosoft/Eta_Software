//
//  PostListingViewModel.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 02/12/21.
//



import Foundation
import UIKit
import CoreData

protocol IPostListingViewModel {
    func numberOfRows()->Int
    func productAtIndexPath(indexPath:IndexPath)->PostList
    func loadProducts(completion:@escaping emptyCompletionHandler)
    func loadProductsUserDetails(id:Int,completion:@escaping NoemptyCompletionHandler)
    func loadProductsFromDb(completion:@escaping LocalPostemptyCompletionHandler)
    
}
class PostListingViewModel : IPostListingViewModel {
    
    private var postService: IPostServices?
    private var connectivity:IConnectivityService?
    // private var userListDict: UserList?
    
    /*
     * Method name: init
     * Description: use to initilise ProductListingViewModel
     * Parameters: productService, connectivity
     */
    init(productService:IPostServices?, connectivity:IConnectivityService?) {
        self.postService = productService
        self.connectivity = connectivity
    }
}

extension PostListingViewModel {
    
    /*
     * Method name: numberOfRows
     * Description: use to get products count
     * Parameters: section
     * Return:  Int
     */
    func numberOfRows()->Int {
        return pList.count
    }
    
    /*
     * Method name: productAtIndexPath
     * Description: use to get product from particular index
     * Parameters: indexPath
     * Return:  Product
     */
    func productAtIndexPath(indexPath:IndexPath)->PostList {
        return pList[indexPath.row]
    }
}
extension PostListingViewModel {
    /*
     * Method name: loadProducts
     * Description: use to get product from api
     * Parameters: completion handler
     * Return:  -
     */
  
    internal func loadProducts(completion:@escaping emptyCompletionHandler) {
        pList.removeAll()
        
        PostCoreData.deleteAllData(entity: "Post")
        if connectivity?.networkConnected == true {
            postService?.getProductListing(completionHandler: { [self] response in
                switch response {
                case .success(value: let response) :
                    if  let responseVal = response as? [PostList] {
                        pList = responseVal
                        PostCoreData.createData(pList: pList)
                        
                    }
                default:
                    break
                }
                completion(pList.count > 0)
            })
        } else {
            completion(false)
        }
    }
    internal func loadProductsFromDb(completion: @escaping LocalPostemptyCompletionHandler) {
        pList = PostCoreData.retrieveData()
        completion(pList)
        
        
        
    }
    
    internal  func loadProductsUserDetails(id: Int,completion: @escaping NoemptyCompletionHandler) {
        if connectivity?.networkConnected == true {
            postService?.getProductUserListing(id:id,completionHandler: { response in
                switch response {
                case .success(value: let response) :
                    userListDict = response
                    //self.updateData(userListDictPass: userListDict)
                default:
                    break
                }
                completion(userListDict!)
                
            })
        } else {
            // completion(false)
        }
    }
}
