//
//  FSInfoVC.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/20.
//

import UIKit

class FSInfoVC: UIViewController, XMLParserDelegate, UITabBarDelegate
{
    @IBOutlet weak var txt_text: UITextField!
    @IBOutlet weak var txt_page: UITextField!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    
    var aryPhotoList: NSMutableArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btn_confirm.isEnabled = false
        btn_confirm.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        txt_text.text = "";
        txt_text.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        txt_page.text = "";
        txt_page.keyboardType = UIKeyboardType.numberPad
        txt_page.addTarget(self, action: #selector(textFieldEdited), for: .editingChanged)
        
        tabBar.delegate = self
    }
    
    private func isNumber(text: String) -> Bool
    {
        let alphaNums = NSCharacterSet.decimalDigits
        let inStringSet = NSCharacterSet(charactersIn: text)
        return alphaNums.isSuperset(of: inStringSet as CharacterSet)
    }

    @objc func buttonClick()
    {
        aryPhotoList = NSMutableArray()
        aryPhotoList.removeAllObjects()
        
        if self.isNumber(text: txt_page.text!)
        {
            FlickrApi.searchPhoto(text: txt_text.text!, page: Int(txt_page.text!)!, delegate: self)
        }
        else
        {
            let alert = UIAlertController(title: "invalid input", message: "\"Per Page\" must be number", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func textFieldEdited()
    {
        if ( txt_text == nil || txt_text.text == "" )
        {
            btn_confirm.isEnabled = false
            return
        }
        
        if ( txt_page == nil || txt_page.text == "" )
        {
            btn_confirm.isEnabled = false
            return
        }
        
        btn_confirm.isEnabled = true
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        if elementName == "photo"
        {
            let photo = FlickrPhoto(photoId: attributeDict["id"]!, owner: attributeDict["owner"]!)
            photo.title = attributeDict["title"]!
            aryPhotoList.add(photo)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser)
    {
        DispatchQueue.main.async
        {
            // push to next view;
            let vc = FSResultVC(PhotoList: self.aryPhotoList, nibName: "FSResultVC", bundle: nil)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        let vc = FSFavoriteVC()
        self.present(vc, animated: true, completion: nil)
    }
}
