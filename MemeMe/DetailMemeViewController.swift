//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by Eyvind on 13/4/22.
//

import Foundation
import UIKit

class DetailMemeViewController : UIViewController, UINavigationControllerDelegate{
    
    
    static func launchDetail(_ originVC: UIViewController, meme: Meme, indexMeme: Int){
        let controller = originVC.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewController") as! DetailMemeViewController
        controller.indexMeme = indexMeme
        originVC.navigationController?.pushViewController(controller, animated: true)
    }
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var imgMeme: UIImageView!

    private var indexMeme:Int = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
        populateMeme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func editMeme() {
        ViewController.launchEdit(self, meme: memes[indexMeme], indexMeme: indexMeme)
    }
    
    func populateMeme(){
        let meme = memes[indexMeme]
        imgMeme.image = meme.memedImage
    }
    
    
}
