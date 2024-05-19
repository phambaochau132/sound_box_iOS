//
//  BaseController.swift
//  SoundBox
//
//  Created by QTS Mobile on 02/05/2024.
//
import FirebaseDatabase
import UIKit
class BaseController{
    public static let ref = Database.database().reference()

    
   static func loadImage(url:String)->UIImage{
        let url = URL(string: url)
        var data:Data?
        var result:UIImage?
            do{
                data=try Data(contentsOf:url!)
                result = UIImage(data: data!)
            }catch{
                fatalError("Loi data!")
            }
       return result ?? UIImage(named: "default")!
    }

}
