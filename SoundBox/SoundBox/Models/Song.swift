//
//  Song.swift
//  SoundBox
//
//  Created by QTS Mobile on 01/05/2024.
//
import Foundation
class Song:NSObject {
    private let id:String
    private let name:String
    private let singer:String
    private let thumbnail:String
    private let file_path:String
    private var rating:Int
    
    init(id: String, name: String, singer: String, thumbnail: String, file_path: String, rating: Int) {
        self.id = id
        self.name = name
        self.singer = singer
        self.thumbnail = thumbnail
        self.file_path = file_path
        self.rating = rating
    }
    override init() {
        self.id = ""
        self.name = ""
        self.singer = ""
        self.thumbnail = ""
        self.file_path = ""
        self.rating = 0
    }
    
    func getID()->String{
        return self.id
    }
    func getName()->String{
        return self.name
    }
    func getSinger()->String{
        return self.singer
    }
    func getThumbnail()->String{
        return self.thumbnail
    }
    func getFile_path()->String{
        return self.file_path
    }
    func getRating()->Int{
        return self.rating
    }
}
extension Song{
    func parseObjectToDictionary()->[String:Any]{
        return [
            "id": self.getID(),
            "name": self.getName(),
            "singer": self.getSinger(),
            "thumbnail": self.getThumbnail(),
            "file_path": self.getFile_path(),
            "rating": self.getRating()]
    }
}
