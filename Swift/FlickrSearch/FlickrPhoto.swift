//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/20.
//

import UIKit

protocol FlickrPhoto_Delegate
{
    func photoLoadComplete()
}

class FlickrPhoto: NSObject, XMLParserDelegate
{
    var photo_id: String
    var photo_owner: String
    var photo_source: String
    var image: UIImage?
    var delegate: FlickrPhoto_Delegate?
    
    init(photoId: String, owner: String)
    {
        photo_id = photoId
        photo_owner = owner
        photo_source = ""
        image = nil
        delegate = nil
        
        super.init()
    }
    
    func loadImage()
    {
        FlickrApi.getImageSource(photoId: photo_id, delegate: self)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if elementName == "size"
        {
            if let obj = attributeDict["source"]
            {
                photo_source = obj
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "sizes"
        {
            let url = URL(string: photo_source)!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                self.image = UIImage(data: data!)
                self.delegate?.photoLoadComplete()
            }
            task.resume()
        }
    }
}
