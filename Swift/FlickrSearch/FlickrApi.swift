//
//  FlickrApi.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/20.
//

import UIKit

class FlickrApi: NSObject, XMLParserDelegate
{
    override init()
    {
        super.init()
    }
    
    static func session() -> URLSession
    {
        return URLSession.init(configuration: URLSessionConfiguration.default)
    }
    
    static func apiKey() -> String
    {
        return String("aad71bc325f1361c0bf1688e0066064f")
    }

    static func searchPhoto(text: String, page: Int, delegate: XMLParserDelegate)
    {
        let url = FlickrApi.apiURL_searchPhoto(text: text, perpage: page)
        
        let task = FlickrApi.session().dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    let parser = XMLParser(data: data)
                    parser.delegate = delegate
                    parser.parse()
                }
            }
        }
        
        task.resume()
    }

    static func getImageSource(photoId: String, delegate: XMLParserDelegate)
    {
        let url = FlickrApi.apiURL_getPhotoSizes(photoId: photoId)
        
        let task = FlickrApi.session().dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    let parser = XMLParser(data: data)
                    parser.delegate = delegate
                    parser.parse()
                }
            }
        }
        
        task.resume()
    }

    static func apiURL_searchPhoto(text: String, perpage: Int) -> URL
    {
        let temp: String.UTF8View = text.utf8
        let keyword = String(temp)
        
        var urlComponent = URLComponents()
        urlComponent.host = "www.flickr.com"
        urlComponent.scheme = "https"
        urlComponent.path = "/services/rest"
        urlComponent.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: FlickrApi.apiKey()),
            URLQueryItem(name: "text", value: keyword),
            URLQueryItem(name: "per_page", value: String(perpage))
        ]
        
        return urlComponent.url!
    }

    static func apiURL_getPhotoSizes(photoId: String) -> URL
    {
        var urlComponent = URLComponents()
        urlComponent.host = "www.flickr.com"
        urlComponent.scheme = "https"
        urlComponent.path = "/services/rest"
        urlComponent.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.getSizes"),
            URLQueryItem(name: "api_key", value: FlickrApi.apiKey()),
            URLQueryItem(name: "photo_id", value: photoId)
        ]
        
        return urlComponent.url!
    }
}
