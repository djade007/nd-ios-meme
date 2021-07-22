//
//  ViewController.swift
//  Meme
//
//  Created by Olajide Afeez on 23/06/2021.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Default texts
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var memedImage: UIImage!
    
    // Called when a new meme has been saved
    var didSave: () -> Void = { () }
    
    let topDelegate = MeTextDelegate()
    let bottomDelegate = MeTextDelegate()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure text fields attributes
        setUpTextFieldProperties(textField: topTextField, text: defaultTopText, delegate: topDelegate)
        setUpTextFieldProperties(textField: bottomTextField, text: defaultBottomText, delegate: bottomDelegate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        shareButton.isEnabled = false
        
        // Disable camera button if there is no camera source available, i.e in Simulators
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unSubscribeToKeyboardNotifications()
    }
    
    @IBAction func cancelEditor(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpTextFieldProperties(textField: UITextField, text: String, delegate: UITextFieldDelegate) {
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = delegate
    }
    
    func hideToolbars(_ hide: Bool) {
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        hideToolbars(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        hideToolbars(false)

        return memedImage
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
        memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.completionWithItemsHandler = {
            _, completed, _, _ in
            
            guard completed else {
                // Early return if the user cancels the action
                return
            }
            
            // Save the meme
            self.save()
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func save() {
            // Create the meme
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // Add to the memes array on the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        didSave()
    }


    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    
    func pickImage(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        
        shareButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // Only shift the view when the bottom text field is being edited
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    

}

