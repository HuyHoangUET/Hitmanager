//
//  UserTableViewController.swift
//  HitsManager
//
//  Created by LTT on 20/11/2020.
//

import Foundation
import UIKit

class UserTableViewController: UIViewController {
    
    // MARK: - outlet
    @IBOutlet weak var hitTableView: UITableView!
    
    private var didLikeHits: [DidLikeHit] = []
    var userViewModel: UserViewModel?
    var didDislikeImagesId: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        didLikeHits = DidLikeHit.getListDidLikeHit()
        hitTableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        scrollToRow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let newDidLikeHits = DidLikeHit.getListDidLikeHit()
        if didLikeHits != newDidLikeHits {
            didLikeHits = newDidLikeHits
            hitTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        for id in didDislikeImagesId {
            DidLikeHit.deleteAnObject(id: id)
        }
    }
}

// Create cell
extension UserTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return didLikeHits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = initHittableViewCell(indexPath: indexPath)
        return cell
    }
}

// Display cell
extension UserTableViewController {
    func initHittableViewCell(indexPath: IndexPath) -> HitTableViewCell {
        guard userViewModel != nil else {
            return HitTableViewCell()
        }
        guard let cell = hitTableView.dequeueReusableCell(withIdentifier: "cell") as? HitTableViewCell else { return HitTableViewCell()}
        guard let hit = didLikeHits[safeIndex: indexPath.row] else {return HitTableViewCell()}
        cell.setItem(hit: hit)
        cell.setHeightOfHitImageView(imageWidth: CGFloat(hit.imageWidth), imageHeight: CGFloat(hit.imageHeight))
        // user imageview
        cell.delegate = self
        if didDislikeImagesId.isSuperset(of: [hit.id]){
            cell.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        }
        self.userViewModel?.dataManager.getImage(url: didLikeHits[indexPath.row].userImageUrl) { (image) in
            cell.setImageForUserImageView(image: image)
            cell.setBoundsToUserImage()
            cell.usernameLabel.text = self.didLikeHits[indexPath.row].username
        }
        // hit imageview
        self.userViewModel?.dataManager.getImage(url: hit.url) { (image) in
            cell.setImageForHitImageView(image: image)
        }
        return cell
    }
}

extension UserTableViewController {
    func scrollToRow(){
        DispatchQueue.main.async {
            guard self.userViewModel != nil else { return }
            if self.userViewModel!.isDisplayCellAtChosenIndexPath {
                self.hitTableView.scrollToRow(at: self.userViewModel?.chosenIndexPath ?? IndexPath(), at: .top, animated: true)
                self.userViewModel!.isDisplayCellAtChosenIndexPath = false
            }
        }
    }
}

extension UserTableViewController: UserTableViewCellDelegate {
    func didLikeImage(id: Int) {
        didDislikeImagesId.remove(id)
    }
    
    func didDisLikeImage(id: Int) {
        didDislikeImagesId.insert(id)
    }
}
