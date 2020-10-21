//
//  DataManager.swift
//  FlickrSearch
//
//  Created by Alfred Yu on 2020/10/21.
//

import UIKit
import SQLite

class DataManager: NSObject
{
    public static let table = Table("photos")
    public static let id = Expression<Int64>("id")
    public static let photo_id = Expression<String?>("photo_id")
    public static let owner = Expression<String?>("owner")
    public static let source = Expression<String?>("source")
    public static let title = Expression<String?>("title")
    
    static func dbConnection() -> Connection
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let db = try? Connection("\(path)/photos.db")
        return db!
    }
    
    static func createDatabaseIfNotExist()
    {
        let db = DataManager.dbConnection()
        
        _ = try? db.run(table.create(ifNotExists: true, block: { (t) in
            t.column(id, primaryKey: true)
            t.column(photo_id)
            t.column(owner)
            t.column(source)
            t.column(title)
        }))
    }
    
    static func addRecord(photoId: String, ownerid: String, sourceurl: String, titletext: String) -> Bool
    {
        let db = DataManager.dbConnection()
        
        do {
            try db.run(table.insert(photo_id <- photoId,
                                    owner <- ownerid,
                                    source <- sourceurl,
                                    title <- titletext))
            return true
        } catch {
            print("insert failed")
            return false
        }
    }
    
    static func queryRecord(photoId: String, ownerId: String, sourceurl: String) -> Bool
    {
        let db = DataManager.dbConnection()
        
        do {
            let query = table.select(id)
                .filter(photo_id == photoId)
                .filter(owner == ownerId)
                .filter(source == sourceurl)
            
            for _ in try db.prepare(query)
            {
                return true
            }
        } catch {
            print("query failed")
        }
        
        return false
    }
    
    static func queryRecord(photoId: String, ownerId: String) -> Bool
    {
        let db = DataManager.dbConnection()
        
        do {
            let query = table.select(id)
                .filter(photo_id == photoId)
                .filter(owner == ownerId)
            
            for _ in try db.prepare(query)
            {
                return true
            }
        } catch {
            print("query failed")
        }
        
        return false
    }
    
    static func queryRecord() -> NSMutableArray
    {
        let db = DataManager.dbConnection()
        let list = NSMutableArray()
        list.removeAllObjects()
        
        do {
            for row in try db.prepare(table)
            {
                let info = FlickrPhoto(photoId: row[photo_id]!, owner: row[owner]!)
                info.photo_source = row[source]!
                info.title = row[title] ?? ""

                list.add(info)
            }
        } catch {
            print("query failed")
        }
        
        return list
    }
    
    static func deleteRecord(photoId: String, ownerId: String) -> Bool
    {
        let db = DataManager.dbConnection()
        
        do {
            let query = table.select(id)
                .filter(photo_id == photoId)
                .filter(owner == ownerId)
            
            try db.run(query.delete())
        } catch {
            print("delete failed")
        }
        
        return false
    }
}
