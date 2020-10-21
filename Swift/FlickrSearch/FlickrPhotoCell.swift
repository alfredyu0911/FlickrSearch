//
//  FlickrPhotoCell.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell, FlickrPhoto_Delegate
{
    @IBOutlet weak var label_id: UILabel!
    @IBOutlet weak var label_owner: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var photoInfo: FlickrPhoto?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        setLoadingComplete(status: false)
        imageViewInit()
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
            activityView.isHidden = true
            activityView.stopAnimating()
        }
        else
        {
            imageView.isHidden = true
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
}
