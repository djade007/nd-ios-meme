//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Olajide Afeez on 15/07/2021.
//

import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController
class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Properties
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let space = CGFloat(12.0)
        
        // short edge of display -- based on the orientation
        let shortestLen = (view.frame.size.width < view.frame.size.height) ? view.frame.size.width : view.frame.size.height
        let dimension = (shortestLen - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.reloadData()
    }
    
    
    @IBAction func createMeme(_ sender: Any) {
        // Get the Storyboard and MemeEditorViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.didSave = { () in
            self.collectionView.reloadData()
        }
        
        // Show page as full screen instead of modal
        memeEditorVC.modalPresentationStyle = .fullScreen
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
}


// MARK: - Extension: UICollectionViewController
extension MemeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.meme = memes[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Instantiate and initialize MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        let item = (indexPath as NSIndexPath).item
        detailController.meme = memes[item]
        
        navigationController?.pushViewController(detailController, animated: true)
    }
}
