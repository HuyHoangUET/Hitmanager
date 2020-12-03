//
//  TableViewCell.swift
//  HitsManager
//
//  Created by LTT on 20/11/2020.
//

import Foundation
import UIKit

class HitTableViewCell: UITableViewCell {
    
    // MARK: - outlet
    @IBOutlet weak var userInforView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hitImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heightOfHitImageView: NSLayoutConstraint!
    
    weak var delegate: UserTableViewCellDelegate?
    private let scale = UIImage.SymbolConfiguration(scale: .large)
    var hit = Hit()
    private let imageManager = ImageManager()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hitImageView.image = nil
        userImageView.image = nil
        usernameLabel.text = ""
        likeButton.setImage(nil, for: .normal)
    }
    
    func setBoundsToUserImage() {
        userImageView.layer.cornerRadius = userImageView.frame.height / 2.0
        userImageView.layer.masksToBounds = true
    }
    
    func setHeightOfHitImageView(imageWidth: CGFloat, imageHeight: CGFloat) {
        let ratio = imageHeight / imageWidth
        let widthOfHitImageView = hitImageView.frame.width
        let heightOfHitImageView = widthOfHitImageView * ratio
        self.heightOfHitImageView.constant = heightOfHitImageView
    }
    
    func setImageForHitImageView() {
        imageManager.getImageForCell(hit: hit) { image in
            self.hitImageView.image = image
        }
    }
    
    func setImageForUserView() {
        usernameLabel.text = hit.username
        setBoundsToUserImage()
        imageManager.getImageForCell(hit: hit) { image in
            self.userImageView.image = image
        }
    }
    
    func handleLikeButton(hit: DidLikeHit, didDislikeImagesId: Set<Int>) {
        if didDislikeImagesId.isSuperset(of: [hit.id]){
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: scale), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: scale), for: .normal)
        }
    }
    // MARK: - action
    @IBAction func likeButton(_ sender: Any) {
        let heartImage = UIImage(systemName: "heart", withConfiguration: scale)
        if likeButton.currentImage != heartImage {
            likeButton.setImage(heartImage, for: .normal)
            delegate?.didDisLikeImage(id: hit.id)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: scale), for: .normal)
            delegate?.didLikeImage(id: hit.id)
        }
    }
}
