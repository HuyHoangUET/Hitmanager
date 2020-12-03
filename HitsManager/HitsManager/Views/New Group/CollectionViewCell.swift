//
//  CollectionViewCell.swift
//  HitsManager
//
//  Created by LTT on 11/2/20.
//

import Foundation
import UIKit
import RealmSwift

class HitCollectionViewCell: UICollectionViewCell {
    // MARK: - outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: HitCollectionViewDelegate?
    let loadingIndicator = UIActivityIndicatorView()
    var hit = Hit()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    func setImage() {
        let imageManager = ImageManager()
        imageManager.getImageForCell(hit: hit) { image in
            self.imageView.image = image
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func showLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center = imageView.center
        loadingIndicator.style = .medium
        loadingIndicator.color = .white
        imageView.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func handleLikeButton(indexPath: IndexPath, hitId: Int) {
        let listDidLikeImageId = DidLikeHit.getListId()
        if listDidLikeImageId.isSuperset(of: [hitId]) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    // MARK: - action
    @IBAction func likeButton(_ sender: UIButton) {
        let heartImage = UIImage(systemName: "heart.fill")
        if sender.currentImage == heartImage {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            delegate?.didDisLikeImage(id: hit.id)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            delegate?.didLikeImage(hit: hit)
            
        }
    }
}
