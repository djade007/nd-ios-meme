//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Olajide Afeez on 20/07/2021.
//

import UIKit

// MARK: - MemeTableViewController: UIViewController
class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Life cycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tableView = self.view as! UITableView
        tableView.reloadData()
    }
    
    // MARK: Actions
    
    @IBAction func createMeme(_ sender: Any) {
        // Get the Storyboard and MemeEditorViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.didSave = { () in
            let tableView = self.view as! UITableView
            tableView.reloadData()
        }
        
        // Show page as full screen instead of modal
        memeEditorVC.modalPresentationStyle = .fullScreen
        
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
}

// MARK: - Extension: UITableViewDelegate, UITableViewDataSource
extension MemeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)
        
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // Instantiate and initialize MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let row = (indexPath as NSIndexPath).row
        detailController.meme = memes[row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = (indexPath as NSIndexPath).row
            
            guard index < memes.count else {
                print("Invalid index: \(index), \(memes.count)")
                return
            }
            
            self.deleteEntryFromMemesArray(index: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: Helper methods
    func deleteEntryFromMemesArray(index indexPath: IndexPath) {
        let index = (indexPath as NSIndexPath).row
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.memes.remove(at: index)
    }
    
    
}
