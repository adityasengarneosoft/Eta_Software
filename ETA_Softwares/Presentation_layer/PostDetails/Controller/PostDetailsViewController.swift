//
//  PostDetailsViewController.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 01/12/21.
//

import UIKit
import SDWebImage
class PostDetailsViewController: UIViewController {
    
    // MARK: - Outlets and Variable
    var postNewGet:PostList? = nil
    @IBOutlet  weak var scllView : UIScrollView!
    @IBOutlet  weak var lblPost_Title : UILabel!
    @IBOutlet  weak var lblPost_body : UILabel!
    @IBOutlet  weak var lblUserName : UILabel!
    @IBOutlet  weak var lblEmail : UILabel!
    @IBOutlet  weak var lblAddress : UILabel!
    @IBOutlet  weak var lblPhone : UILabel!
    @IBOutlet  weak var lblCompamny : UILabel!
    @IBOutlet  weak var imgCompany : UIImageView!
    var viewModelDetails: IPostUserDetailsViewModel?
//    lazy var viewModelDetails:IPostUserDetailsViewModel? = {
//        let productService = PostServices(networkManager: NetworkManager())
//        let connectivity = ConnectivityService()
//        let viewModel = PostUserDetailsViewModel(productService: productService, connectivity: connectivity)
//        return viewModelDetails
//    }()

    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        let productService = PostServices(networkManager: NetworkManager())
        let connectivity = ConnectivityService()
        let viewModel = PostUserDetailsViewModel(productService: productService, connectivity: connectivity)
        self.viewModelDetails = viewModel
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUI()

    }
    // MARK: - Button  Action
    @IBAction func btnBackAction(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnEmailAction(sender:UIButton) {
        let email = userListDict?.email
        if let url = URL(string: "mailto:\(email ?? "")") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func btnPhoneAction(sender:UIButton) {
        dialNumber(number: userListDict?.phone ?? "")
        
    }
    @IBAction func btnAddressAction(sender:UIButton) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(NSURL(string:
                                                "comgooglemaps://?saddr=&daddr=\(userListDict?.geo?.lat ?? ""),\(userListDict?.geo?.lng ?? "")")! as URL)
            
        } else {
            UIApplication.shared.open(NSURL(string:
                                                "https://www.google.co.in/maps/dir/?saddr=&daddr=\(userListDict?.geo?.lat ?? ""),\(userListDict?.geo?.lng ?? "")")! as URL)
        }
    }
    // MARK: - User Defind Function
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    func setupUI(){
        imgCompany.layer.masksToBounds = false
        imgCompany.layer.borderColor = UIColor.black.cgColor
        imgCompany.layer.cornerRadius = imgCompany.frame.height / 2
        imgCompany.clipsToBounds = true
       
        self.loadUserDetails(id: (postNewGet?.userID)!)
        self.loadPostDetails(id: (postNewGet?.postId)!)

    }
    // MARK: - API Response Call Back
    func loadUserDetails(id:Int) {
        viewModelDetails?.loadProductsUserDetails(id: id, completion: { response in
            self.lblUserName.text = response.username
            self.lblEmail.text = response.email
            self.lblAddress.text = "\(response.address?.suite ?? "")\(response.address?.street ?? "")\(response.address?.city ?? "")\(response.address?.zipcode ?? ""))"
            self.lblPhone.text = response.phone
            self.lblCompamny.text = response.company?.name
            let imageString = "\(GlobalValue.img_url)\(response.id ?? 0)"
            self.imgCompany.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "SplashLogo"))
            
            
            
        })
    }
    func loadPostDetails(id:Int) {
        viewModelDetails?.loadProductsPostDetails(id: id, completion: { response in
            self.lblPost_Title.text = response.title
            self.lblPost_body.text = response.body
     
            
            
        })
    }
    
    
}


