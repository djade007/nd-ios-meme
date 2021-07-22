//
//  MemeCollectionViewCell.swift
//  Meme
//
//  Created by Olajide Afeez on 21/07/2021.
//

import UIKit


class MemeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var meme: Meme!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: Life cycle methods
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        self.imageView?.image = self.meme?.memedImage
    }
    
}
