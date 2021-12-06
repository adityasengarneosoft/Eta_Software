//
//  PostDetailsViewModel.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 02/12/21.
//



import Foundation
import UIKit
import CoreData

protocol IPostUserDetailsViewModel {
    
    func loadProductsUserDetails(id:Int,completion:@escaping NoemptyCompletionHandler)
    
    func loadProductsPostDetails(id:Int,completion:@escaping PostListDetailsCompletionHandler)
    
    
}
class PostUserDetailsViewModel : IPostUserDetailsViewModel {
    
    private var postService: IPostServices?
    private var connectivity:IConnectivityService?
     private var postDetailsDict: PostDetails?
    
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

extension PostUserDetailsViewModel {
    /*
     * Method name: loadProducts
     * Description: use to get product from api
     * Parameters: completion handler
     * Return:  -
     */
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
    internal  func loadProductsPostDetails(id: Int,completion: @escaping PostListDetailsCompletionHandler) {
        if connectivity?.networkConnected == true {
            postService?.getProductPostDetailsListing(id:id,completionHandler: { response in
                switch response {
                case .success(value: let response) :
                    self.postDetailsDict = response
                    //self.updateData(userListDictPass: userListDict)
                default:
                    break
                }
                completion(self.postDetailsDict!)
                
            })
        } else {
            // completion(false)
        }
    }
}
