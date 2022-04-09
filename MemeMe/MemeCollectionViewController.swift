//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Eyvind Emilio Tiñini Coaquira on 30/3/22.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet var cvList: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 2.0
print("Dimension: \(dimension)")
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
        
        collectionView.reloadData()
    }
    
    @objc func addNewMeme(){
        ViewController.launchNew(self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
 
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
       // let w = collectionView.frame.width / 3.0 - 3.0-1.0
       // cell.frame.size.width = w
       // cell.frame.size.height = w
        
        let meme = memes[indexPath.row]
        cell.ivMemed?.image = meme.memedImage
        //cell.ivMemed?.frame?.width
        //cell.ivMemed?.image?.size = CGSize(width: cell.frame.width, height: cell.frame.height)
        cell.ivMemed?.frame.size.width = cell.frame.width+100
        cell.ivMemed?.frame.size.height = cell.frame.height+100
        return cell
    }

    
    
}
