//
//  PostListTableViewCell.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 01/12/21.
//

import UIKit

class PostListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var lblPost_Title : UILabel!
    @IBOutlet private weak var lblPost_body : UILabel!
    @IBOutlet  weak var lblUsername : UILabel!
    @IBOutlet  weak var lblCompanyName : UILabel!
    private var userListDict: UserList?
    var viewModel: IPostListingViewModel?

    
    var postNew: PostList! {
            didSet {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // your code here
                    self.loadUserDetails(id: self.postNew.userID!)

                }
            }
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        let productService = PostServices(networkManager: NetworkManager())
        let connectivity = ConnectivityService()
        let viewModel = PostListingViewModel(productService: productService, connectivity: connectivity)
        self.viewModel = viewModel
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setProductData(product:PostList?) {
        if let product = product {
            lblPost_Title.text = product.title
            lblPost_body.text = product.body
        }
    }
  
    
    func loadUserDetails(id:Int) {
        viewModel?.loadProductsUserDetails(id: id, completion: { response in
            self.lblUsername.text = response.username
            self.lblCompanyName.text = response.company?.name

            
        })
    }
}
