//
//  FlickrSearchResultVC.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

import UIKit

extension UIColor
{
   convenience init(red: Int, green: Int, blue: Int)
   {
       assert(red >= 0 && red <= 255, "invalid red value")
       assert(green >= 0 && green <= 255, "invalid green value")
       assert(blue >= 0 && blue <= 255, "invalid blue value")

       self.init(red: CGFloat(red) / 255.0,
                 green: CGFloat(green) / 255.0,
                 blue: CGFloat(blue) / 255.0,
                 alpha: 1.0)
   }

   convenience init(hex: Int)
   {
       self.init(red: (hex >> 16) & 0xFF,
                 green: (hex >> 8) & 0xFF,
                 blue: hex & 0xFF)
   }
}

class FlickrSearchResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label_notFound: UILabel!
    var photoList: NSMutableArray!
    let kGap: CGFloat = 20.0
    let kColumns: CGFloat = 2.0
    
    init(PhotoList list: NSMutableArray?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        photoList = list
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if photoList.count > 0
        {
            collectionViewInit()
            self.label_notFound.isHidden = true
        }
        else
        {
            self.label_notFound.isHidden = false
        }
    }
    
    func collectionViewInit()
    {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical
        
        collectionView.backgroundColor = UIColor.init(hex: 0xEFF0F8)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag

        collectionView.register(UINib(nibName: "FlickrPhotoCell", bundle: nil), forCellWithReuseIdentifier: "id_FlickrPhotoCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photoList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let dequeueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "id_FlickrPhotoCell", for: indexPath)
        
        if let cell = dequeueCell as? FlickrPhotoCell
        {
            if indexPath.row < photoList.count
            {
                if let info = photoList[indexPath.row] as? FlickrPhoto
                {
                    cell.label_id.text = info.photo_id
                    cell.label_owner.text = info.photo_id
                    cell.loadImage(photoinfo: info)
                }
            }
            
            return cell;
        }
        
        return dequeueCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = self.view.frame.size.width
        let noGap = (width - 2*kGap - (kColumns-1)*kGap)
        let size = noGap / 2.0

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: kGap, left: kGap, bottom: kGap, right: kGap)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return kGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return kGap
    }
}
