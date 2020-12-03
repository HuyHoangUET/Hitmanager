//
//  ImageManager.swift
//  HitsManager
//
//  Created by LTT on 01/12/2020.
//

import Foundation
import UIKit

class ImageManager {
    let imageCache = NSCache<AnyObject, AnyObject>()
    private let viewModel = ViewModel()
    
    func cacheImage(image: UIImage, idImage: Int) {
        imageCache.setObject(image, forKey: "\(idImage)" as NSString)
    }
    
    func getImageForCell(hit: Hit, completion: @escaping (UIImage) -> ()) {
        let image = imageCache.object(forKey: "\(hit.id)" as NSString) as? UIImage
        if image == nil {
            viewModel.dataManager.getImage(url: hit.imageURL) { image in
                self.imageCache.setObject(image, forKey: "\(hit.id)" as NSString)
                completion(image)
            }
        } else {
            completion(image ?? UIImage())
        }
    }
}
