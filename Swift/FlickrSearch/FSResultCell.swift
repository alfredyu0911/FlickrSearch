//
//  FSResultCell.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

import UIKit

class FSResultCell: UICollectionViewCell, FlickrPhoto_Delegate
{
    enum FavoriteStatus : Int {
        case Selected = 1
        case UnSelected = 2
    }
    
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
        favoriteIconInit()
        
        favorite.image = UIImage(systemName: "heart")
        favorite.tag = 0
    }
    
    private func imageViewInit()
    {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 9
        imageView.contentMode = .scaleAspectFill
    }
    
    private func favoriteIconInit()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(favIconOnClick))
        favorite.isUserInteractionEnabled = true
        favorite.addGestureRecognizer(tap)
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
        
        guard (photoInfo != nil) else { return }
        
        if DataManager.queryRecord(photoId: photoInfo!.photo_id, ownerId: photoInfo!.photo_owner)
        {
            setCellIsSelectedAsFavorite(isSelected: true)
        }
        else
        {
            setCellIsSelectedAsFavorite(isSelected: false)
        }
    }
    
    private func setCellIsSelectedAsFavorite(isSelected: Bool)
    {
        if isSelected
        {
            favorite.image = UIImage(systemName: "heart.fill")
            favorite.tag = FSResultCell.FavoriteStatus.Selected.rawValue
        }
        else
        {
            favorite.image = UIImage(systemName: "heart")
            favorite.tag = FSResultCell.FavoriteStatus.UnSelected.rawValue
        }
    }
    
    private func switchCellSelected()
    {
        if favorite.tag == FSResultCell.FavoriteStatus.Selected.rawValue
        {
            _ = DataManager.deleteRecord(photoId: photoInfo!.photo_id, ownerId: photoInfo!.photo_owner)
            setCellIsSelectedAsFavorite(isSelected: false)
        }
        else if favorite.tag == FSResultCell.FavoriteStatus.UnSelected.rawValue
        {
            _ = DataManager.addRecord(photoId: self.photoInfo!.photo_id, ownerid: self.photoInfo!.photo_owner, sourceurl: self.photoInfo!.photo_source)
            setCellIsSelectedAsFavorite(isSelected: true)
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
        switchCellSelected()
    }
}
