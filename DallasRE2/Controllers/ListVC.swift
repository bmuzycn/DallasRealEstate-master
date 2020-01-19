//
//  LunchVC.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit

class ListVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let titleFont: UIFont = UIFont.init(name: "AvenirNext-DemiBold", size: 17)!
    
    private let cellID = "listCell"
    
    private let cellHeight: CGFloat = 180
    
    private var imagesURL = Array<String>()
        
    private var prices = Array<String>()
    
    private var addresses = Array<String>()
    
    private var beds = Array<Int>()
    
    private var baths = Array<Int>()
    
    private var sqfts = Array<String>()
    
    private var lots = Array<String>()

    private var lats = Array<Double>()
    
    private var lngs = Array<Double>()
    
    private var phones = Array<String>()
    
    private var twitters = Array<String>()
    
    private var fetchResult = Array<Property>()

    private var numberOfCell = 0
        
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return spinner
    }()
    
    var homeControllerDelegate: HomeControllerDelegate?

    
   fileprivate func addSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        let mySpinnerConstraints = [
            NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)]
        view.addConstraints(mySpinnerConstraints)
    }
        
    fileprivate func fetchData() {
        let urlPath = Bundle.main.path(forResource: "DALLAS", ofType: "jpg")
        let fileURL = URL.init(fileURLWithPath: urlPath!)
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }

        NetworkHelper.getData { (result) in
            if let result = result as? [Property]{
                self.fetchResult = result
                self.numberOfCell = result.count
                for property in result {
                    self.imagesURL.append(property.photo ?? fileURL.absoluteString)
                    self.addresses.append(property.address)
                    self.prices.append(property.price)
                    self.baths.append(property.baths)
                    self.beds.append(property.beds)
                    self.sqfts.append(property.sqft)
                    self.lots.append(property.lot_size ?? "")
                    self.lats.append(property.lat)
                    self.lngs.append(property.lon)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.spinner.stopAnimating()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSpinner()
        fetchData()
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true

        //Mark: set map button here:
        let mapButton = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .plain, target: self, action: #selector(pressMapButton))
        self.navigationItem.setRightBarButton(mapButton, animated: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))

        
        // set title here:
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        title.text = "For Sale".localized
        title.font = titleFont
        title.textColor = UIColor.white
        navigationItem.titleView = title
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    // segue to mapView
    @objc func pressMapButton() {
        let mapVC = DetailVC()
        mapVC.properties = fetchResult
        mapVC.mapConstrainForFull()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc func orientationDidChange() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func handleMenuToggle() {
        homeControllerDelegate?.handleMenuToggle(forMenuOption: nil)
    }

    
    // MARK: - Do some delegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    
    // set cell size here:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        let cellwidth = screenWidth
        let model = UIDevice.current.model
        if model.contains("iPad") || cellwidth > 500 {
            return CGSize(width: cellwidth/2, height: cellHeight)
        }
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //segue to detailVC
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.address1Label.text = addresses[indexPath.item]
        detailVC.priceLabel.text = prices[indexPath.item]
        detailVC.sqftLabel.text = sqfts[indexPath.item]
        detailVC.bedsLabel.text = "Beds: \(beds[indexPath.item])"
        detailVC.bathsLabel.text = "Baths: \(baths[indexPath.item])"
        detailVC.properties = [fetchResult[indexPath.item]]
        detailVC.updateLayout()
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    // return reuseable cell:
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ListCell
        if indexPath.item < imagesURL.count {
            let url = imagesURL[indexPath.item]
            
            /*   get image data using cache        */
            cell.imageView.loadImageAsync(with: url)
            cell.address.text = addresses[indexPath.item]
            cell.price.text = prices[indexPath.item]
        }

//        let bgView = UIImageView(frame: cell.frame)
//        bgView.image = UIImage(named: "cellGradientBackground")
//        bgView.contentMode = .scaleToFill
//        bgView.frame = cell.frame
        let bgView = UIView()
        bgView.backgroundColor = UIColor(patternImage:#imageLiteral(resourceName: "cellGradientBackground"))
        bgView.frame = cell.frame
        cell.backgroundView = bgView
        return cell
    }

    
    // MARK: loading image urls
    func loadImagesURL(_ result: [Property]) {
        for property in result {
            if let imageURL = property.photo {
                imagesURL.append(imageURL)
            } else {
                let urlPath = Bundle.main.path(forResource: "DALLAS", ofType: "jpg")
                let fileURL = URL.init(fileURLWithPath: urlPath!)
                imagesURL.append(fileURL.absoluteString)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    //MARK: remove the back button text
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}




