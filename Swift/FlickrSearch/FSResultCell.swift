//
//  FSResultCell.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

import UIKit

class FSResultCell: UICollectionViewCell, FlickrPhoto_Delegate
{
    @IBOutlet weak var label_id: UILabel!
    @IBOutlet weak var label_owner: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favorite: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var photoInfo: FlickrPhoto?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        setLoadingComplete(status: false)
        imageViewInit()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(favIconOnClick))
        favorite.isUserInteractionEnabled = true
        favorite.addGestureRecognizer(tap)
        
        favorite.image = UIImage(systemName: "heart")
        favorite.tag = 0
    }

    public func loadImage(photoinfo: FlickrPhoto)
    {
        self.photoInfo = photoinfo;
        
        if photoinfo.image == nil
        {
            setLoadingComplete(status: false)
            
            DispatchQueue.global(qos: .userInitiated).async
            {
                self.photoInfo?.loadImage()
                self.photoInfo?.delegate = self
            }
        }
        else
        {
            setPhoto()
        }
    }
    
    private func imageViewInit()
    {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 9
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setLoadingComplete(status: Bool)
    {
        if status
        {
            imageView.isHidden = false
            favorite.isHidden = false
            activityView.isHidden = true
            activityView.stopAnimating()
        }
        else
        {
            imageView.isHidden = true
            favorite.isHidden = true
            activityView.isHidden = false
            activityView.startAnimating()
        }
    }
    
    private func setPhoto()
    {
        imageView.image = photoInfo?.image
        setLoadingComplete(status: true)
    }
    
    public func photoLoadComplete()
    {
        DispatchQueue.main.async
        {
            self.setPhoto()
        }
    }
    
    @objc private func favIconOnClick()
    {
        if favorite.tag == 0
        {
            favorite.image = UIImage(systemName: "heart.fill")
            favorite.tag = 1
        }
        else
        {
            favorite.image = UIImage(systemName: "heart")
            favorite.tag = 0
        }
    }
}
