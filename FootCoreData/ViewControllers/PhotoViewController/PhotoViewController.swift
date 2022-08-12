//
//  PhotoViewController.swift
//  FootCoreData
//
//  Created by Max on 25.07.2022.
//

import Foundation
import UIKit


class PhotoViewController: UIViewController {
 
    @IBOutlet weak var collectionView: UICollectionView?
    
    var saveBlock: ((_ icon: UIImage) -> Void)?
    
    private var selectedIndexPath: IndexPath?
    
    var resaltSelectScreen: PhotoScreenConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = resaltSelectScreen?.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePushIcon))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func savePushIcon() {        
        guard let resaltSelectScreen = resaltSelectScreen else { return }
        
        if let selectedIndexPath = selectedIndexPath {
            let icon = resaltSelectScreen.arrayImg[selectedIndexPath.row]
            saveBlock?(icon)
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resaltSelectScreen?.arrayImg.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let resaltSelectScreen = resaltSelectScreen else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
        if let imgCell = cell as? ImageCell {
            imgCell.imgCell?.backgroundColor = (indexPath == selectedIndexPath) ? .green : .darkGray
            imgCell.imgCell?.image = resaltSelectScreen.arrayImg[indexPath.row]
        }
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        navigationItem.rightBarButtonItem?.isEnabled = true
        collectionView.reloadData()
    }
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imgCell: UIImageView?
}
