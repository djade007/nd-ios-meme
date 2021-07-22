//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Olajide Afeez on 22/07/2021.
//

import UIKit


// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life cycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = meme.memedImage
    }
}
