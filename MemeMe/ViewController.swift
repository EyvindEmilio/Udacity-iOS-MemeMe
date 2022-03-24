//
//  ViewController.swift
//  MemeMe
//
//  Created by Eyvind on 22/3/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    @IBOutlet weak var tfTop: UITextField!
    @IBOutlet weak var tfBottom: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var btnShare: UIBarButtonItem!
    
    // MARK: Extra Properties
    private var memedImage: UIImage?
    private let memeTextFieldTOP = MemeTextFieldDelegate(defaultText: "TOP")
    private let memeTextFieldBOTTOM = MemeTextFieldDelegate(defaultText: "BOTTOM")
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 32)!,
        NSAttributedString.Key.strokeWidth: -4
    ]
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfTop.defaultTextAttributes = memeTextAttributes
        tfBottom.defaultTextAttributes = memeTextAttributes
        
        tfTop.textAlignment = .center
        tfBottom.textAlignment = .center
        
        tfTop.delegate = memeTextFieldTOP
        tfBottom.delegate = memeTextFieldBOTTOM
        
        resetMeme()
    }
    
    // MARK: Actions
    @IBAction func share(_ sender: Any) {
        self.memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
                self.resetMeme()
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
      
    @IBAction func cancelMeme(_ sender: Any) {
        resetMeme()
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imgView.image = image
            enableSharing()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if imgView.image == nil {
            disableSharing()
        }
        picker.dismiss(animated: true)
    }

    // MARK: Other Functions
    
    private func resetMeme() {
        memeTextFieldTOP.resetTextField(tfTop)
        memeTextFieldBOTTOM.resetTextField(tfBottom)
        imgView.image = nil
        disableSharing()
    }
    
    private func enableSharing(){
        btnShare.isEnabled = true
    }
    
    private func disableSharing(){
        btnShare.isEnabled = false
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if tfBottom.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        let meme = Meme(topText: tfTop.text!, bottomText: tfBottom.text!, originalImage: imgView.image!, memedImage: memedImage!)
        print("MemeSaved!: \(meme)")
    }
    
    func generateMemedImage() -> UIImage {

        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }

}

