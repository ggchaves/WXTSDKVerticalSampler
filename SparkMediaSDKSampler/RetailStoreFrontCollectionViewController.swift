//
//  InfiniteViewController.swift
//  LNZCollectionLayouts
//
//  Created by Giuseppe Lanza on 18/07/17.
//  Copyright © 2017 Gilt. All rights reserved.
//

import UIKit

class RetailStoreFrontCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        self.navigationItem.title = UserDefaults.standard.value(forKey: "retailStoreName") as! String?
        var items = [UIBarButtonItem]()
        
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil) ) // replace add with your function
        
        self.toolbarItems = items // this made the difference. setting the items to the controller, not the navigationcontroller
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let label = cell.contentView.viewWithTag(10)! as! UILabel
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        
        label.text = "\(indexPath.item)"
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print("Pressed \(indexPath.row)")
    }
    
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RetailStoreFrontCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var identifier = "header"
        if kind == UICollectionElementKindSectionFooter {
            identifier = "footer"
        }
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        supplementaryView.backgroundColor = UIColor.lightGray
        let label = supplementaryView.viewWithTag(99) as? UILabel ?? UILabel(frame: supplementaryView.bounds)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.textAlignment = .center
        label.text = identifier
        
        if label.superview == nil {
            supplementaryView.addSubview(label)
        }
        
        return supplementaryView
    }
}

