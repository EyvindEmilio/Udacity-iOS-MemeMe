//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Eyvind Emilio Tiñini Coaquira on 30/3/22.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    final let ITEMS_PER_ROW_PORTRAIT = 3.0
    final let ITEMS_PER_ROW_LASDSCAPE = 4.0
    final let CELL_SPACES = 3.0
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyFlowLayoutSpaces()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
        collectionView.reloadData()
    }
    
    @objc func addNewMeme(){
        ViewController.launchNew(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        cell.ivMemed?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        ViewController.launchEdit(self, meme: meme, indexMeme: indexPath.row)
    }
    
    
    private func applyFlowLayoutSpaces(){
        flowLayout.sectionInset.right = CELL_SPACES
        flowLayout.sectionInset.left = CELL_SPACES
        flowLayout.minimumInteritemSpacing = CELL_SPACES
        flowLayout.minimumLineSpacing = CELL_SPACES
        flowLayout.itemSize = getCellSize()
    }
    
    private func getCellSize() -> CGSize{
        let itemsPerRow = self.interfaceOrientation.isPortrait ? ITEMS_PER_ROW_PORTRAIT : ITEMS_PER_ROW_LASDSCAPE
        // Per each item there are n - 1 spaces to add between them and also adding the left and right is n - 1 + 2, then the result is n + 1
        let dimension = (collectionView.frame.size.width - ((itemsPerRow + 1.0) * CELL_SPACES)) / itemsPerRow
        return CGSize(width: dimension, height: dimension)
    }

}
