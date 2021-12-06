//
//  PostList_ViewController.swift
//  Scoot911_Aditya
//
//  Created by A1502 on 01/12/21.
//

import UIKit
import CoreData
import Toast_Swift
class PostList_ViewController: UIViewController {
    
    @IBOutlet private weak var tblList: UITableView!
    var refreshControl: UIRefreshControl!
    // MARK: - Properties
    lazy var viewModel:IPostListingViewModel? = {
        let productService = PostServices(networkManager: NetworkManager())
        let connectivity = ConnectivityService()
        let viewModel = PostListingViewModel(productService: productService, connectivity: connectivity)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewSetup()
        loadProductsFromLocal()
    }
    
    
    private func initViewSetup(){
        tblList.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self, action: #selector(refresh_API), for: .valueChanged)
        tblList.addSubview(refreshControl)
        tblList.tableFooterView = UIView()
        
        
    }
    func loadProductsFromLocal() {
        viewModel?.loadProductsFromDb(completion: { response in
            if  self.viewModel?.numberOfRows() == 0  {
                self.loadProducts()
            } else {
                DispatchQueue.main.async {
                    if response.count>0{
                        self.tblList.reloadData()
                    }
                }
            }
        })
        
    }
    func loadProducts() {
        viewModel?.loadProducts(completion: { response in
            if response == false {
                DispatchQueue.main.async { [weak self] in
                    self?.openAlert(title: "App Name",
                                    message: ErrorMessages.Network.noNetwork,
                                    alertStyle: .alert,
                                    actionTitles: ["Okay", "Cancel"],
                                    actionStyles: [.default, .cancel],
                                    actions: [
                                        {_ in
                                            print("okay click")
                                            self?.loadProducts()
                                        },
                                        {_ in
                                            print("cancel click")
                                        }
                                    ])                }
            }
            else {
                DispatchQueue.main.async {
                    if  self.viewModel?.numberOfRows() == 0  {
                        self.view.makeToast(ErrorMessages.PostListM.noData)
                    } else {
                        self.tblList.reloadData()
                    }
                    self.refreshControl.endRefreshing()
                }
            }
            
        })
    }
    @objc func refresh_API(_ sender: Any) {
        loadProducts()
    }
    
    
}
// MARK: - UITableView DataSource
extension PostList_ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cellObj = tableView
            .dequeueReusableCell(withIdentifier: "PostListTableViewCell") as? PostListTableViewCell
        guard let cell = cellObj else {
            return UITableViewCell()
        }
        let product = self.viewModel?.productAtIndexPath(indexPath:indexPath)
        DispatchQueue.main.async {
            cellObj?.setProductData(product: product)
            cellObj?.postNew = product
        }
        
        return cell
    }
    
}
// MARK: - UITableView Delegate
extension PostList_ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.viewModel?.productAtIndexPath(indexPath:indexPath)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        vc.postNewGet = product
        self.present(vc, animated: true, completion: nil)
        
    }
}
