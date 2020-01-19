//
//  ImageCache.swift
//  LunchTyme
//
//  Created by Yu Zhang on 8/4/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        // make sure to purge cache on memory pressure
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil, using: { [weak self](notification) in
            self?.cache.removeAllObjects()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

extension UIImageView {
    
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImageAsync(with urlString: String?) {
        //add a indicator spinner
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)])
        DispatchQueue.main.async {
                activityIndicator.startAnimating()
        }

        // cancel prior task, if any
        
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        
        // reset imageview's image
        
        self.image = nil
        
        // allow supplying of `nil` to remove old image and then return immediately
        
        guard let urlString = urlString else { return }
        
        // check cache
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
            print("Load image from cache")
            return
        }
        
        // download
        
        guard let url = URL(string: urlString) else {return}
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            
            //error handling
            
            if let error = error {
                // don't bother reporting cancelation errors
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                
                print(error)
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
                return
            }
            
            ImageCache.shared.save(image: downloadedImage, forKey: urlString)
            
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                    activityIndicator.stopAnimating()
                    print("load image from internet")
                }
            }
        }
        
        // save and start new task
        
        currentTask = task
        task.resume()
    }
    
}
