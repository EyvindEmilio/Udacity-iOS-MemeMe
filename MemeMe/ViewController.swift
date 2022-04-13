//
//  ViewController.swift
//  MemeMe
//
//  Created by Eyvind on 22/3/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static func launchNew(_ originVC: UIViewController){
        let controller = originVC.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! ViewController
        
        originVC.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    static func launchEdit(_ originVC: UIViewController, meme: Meme, indexMeme: Int){
        let controller = originVC.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! ViewController
        controller.meme = meme
        controller.indexMeme = indexMeme
        originVC.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    private var meme:Meme? = nil
    private var indexMeme:Int = -1
    
    // MARK: Outlets
    @IBOutlet var viewContentMeme: UIView!
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
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 30)!,
        NSAttributedString.Key.strokeWidth: -4
    ]
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
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
        
        populateMeme()
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
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFromSource(source: .camera)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        pickAnImageFromSource(source: .photoLibrary)
    }
    
    // MARK: Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
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
    
    private func populateMeme() {
        if let _meme = self.meme{
            memeTextFieldTOP.setText(tfTop, _meme.topText)
            memeTextFieldBOTTOM.setText(tfBottom, _meme.bottomText)
            memedImage = _meme.memedImage
            imgView.image = _meme.originalImage
            enableSharing()
        }
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
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        if indexMeme >= 0 {
            appDelegate.memes[indexMeme] = meme
        } else {
            appDelegate.memes.append(meme)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func generateMemedImage() -> UIImage {
        
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        self.viewContentMeme.invalidateIntrinsicContentSize()
        //let rect = CGRect(x: self.viewContentMeme.frame.origin.x, y: self.viewContentMeme.frame.origin.y, width: self.viewContentMeme.frame.width, height: self.viewContentMeme.frame.height)
       
        UIGraphicsBeginImageContext(viewContentMeme.frame.size)
        
        viewContentMeme.drawHierarchy(in: viewContentMeme.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    func pickAnImageFromSource(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
}

