//
//  FSFavoriteVC.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

import UIKit

class FSFavoriteVC: FSResultVC
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    init()
    {
        super.init(PhotoList: DataManager.queryRecord(), nibName: "FSResultVC", bundle: nil)
        str_notFound = "Empty !!";
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
