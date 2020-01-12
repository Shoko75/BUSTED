//
//  Components.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-26.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

// MARK: UIViewController extension
extension UIViewController {
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertSheet(style: UIAlertController.Style, title: String?, message: String?, actions:[UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: ( () -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UIImageView extension
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        // check cache wether image is aleady exsist
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }
        }).resume()
    }
}
