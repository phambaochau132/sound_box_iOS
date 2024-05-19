//
//  PlayingController.swift
//  SoundBox
//
//  Created by QTS Mobile on 06/05/2024.
//

import UIKit
import AVFAudio
import AVFoundation

class PlayingController: UIViewController, AVAudioPlayerDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleNavigation: UINavigationItem!
    @IBOutlet weak var favouriteSong: UIBarButtonItem!
    var listSong:[Song]?
    var selectedSong:Song?
    var changeSong=false
    private var player:AVAudioPlayer?
    private var timer:Timer?
    private var isFavourite:Bool=false
    
    enum Position{
        case next
        case pre
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func initial(){
        if let selectedSong = selectedSong{
            if changeSong{
                titleNavigation.title=selectedSong.getName()+" - "+selectedSong.getSinger()
                nameSong.text=selectedSong.getName()
                singer.text=selectedSong.getSinger()
                DispatchQueue.main.async { [self] in
                    //Khoi tao tinh trang yeu thich
                    setInitFavourite()
                }
                DispatchQueue.main.async { [self] in
                    //Them bai hat vao danh sach nghe gan day
                    addRecentSong(song: selectedSong)
                    let homeController=tabBarController?.viewControllers![0] as! HomeController
                    homeController.changeRecentSongs=true
                }
                DispatchQueue.main.async { [self] in
                    imageSong.image=BaseController.loadImage(url: selectedSong.getThumbnail())
                }
                DispatchQueue.main.async {
                    self.loadMusic()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        changeSong=false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initial()
    }
    
    func addRecentSong(song:Song) {
        BaseController.ref.child("recentSongs").child("\(song.getID())").removeValue()
        BaseController.ref.child("recentSongs").child("\(song.getID())").setValue(song.parseObjectToDictionary())
    }
    
    func setInitFavourite(){
        if let selected = selectedSong{
            favouriteSong.image = UIImage(systemName: "heart")
            BaseController.ref.child("favouriteSongs").observeSingleEvent(of: .value, with:{ [self]DataSnapshot in
                if DataSnapshot.hasChild("\(selected.getID())"){
                    favouriteSong.image = UIImage(systemName: "heart.fill")
                    isFavourite=true
                }
            })
        }
            
     }
    
    func setChangeFavourite(){
        if let selected = selectedSong{
            if isFavourite{
                isFavourite=false
                BaseController.ref.child("favouriteSongs").child("\(selected.getID())").removeValue()
                favouriteSong.image = UIImage(systemName: "heart")
            }
            else{
                isFavourite=true
                BaseController.ref.child("favouriteSongs").child("\(selected.getID())").setValue(selected.parseObjectToDictionary())
                favouriteSong.image = UIImage(systemName: "heart.fill")
            }
        }
    }
    
    @IBAction func addFavouriteSong(_ sender: UIBarButtonItem) {
        setChangeFavourite()
        let favouriteController=tabBarController?.viewControllers![2] as! FavouriteController
        favouriteController.changeFavouriteList=true
    }
    
    @IBAction func playingMusic(_ sender: UIButton){
        if let player=player{
            if player.isPlaying{
                onPauseSong()
            }
            else{
                onResumeSong()
            }
        }
    }
    
    @IBAction func decreaseDuration(_ sender: Any) {
        if let player = player{
            if player.currentTime>=10{
                self.player!.currentTime=player.currentTime-10
            }
            else{
                onChangeSong(position: Position.pre)
            }
        }
    }
    
    @IBAction func increaseDuration(_ sender: Any) {
        if let player = player{
            if player.currentTime<=player.duration-10{
                self.player!.currentTime=player.currentTime+10
            }
            else{
                onChangeSong(position: Position.next)
            }
        }
    }
    
    @IBAction func preSong(_ sender: Any) {
        onChangeSong(position: Position.pre)
    }
    
    @IBAction func nextSong(_ sender: Any) {
        onChangeSong(position: Position.next)
    }
    
    func onChangeSong(position:Position){
            if let listSong=listSong{
                for i in 0..<listSong.count{
                    if listSong[i].getID() == selectedSong?.getID(){
                        if position == Position.next{
                            selectedSong=(i != listSong.count - 1) ? listSong[i+1] : listSong[0]
                        }
                        else{
                            selectedSong=(i != 0) ? listSong[i-1] : selectedSong
                        }
                        initial()
                        break
                    }
                }
            }
    }
    
    func onStopSong(){
        if player != nil{
            onPauseSong()
            self.currentTime.text=0.convertSecondToMinute()
            self.endTime.text=0.convertSecondToMinute()
            self.progressBar.progress=Float(0)
            player=nil
            timer=nil
        }
    }
    func onPauseSong(){
        if let player=player{
                player.pause()
                timer?.invalidate()
                btnPlay.setImage(UIImage(systemName: "arrowtriangle.forward.fill"), for: .normal)
        }
    }
    func onResumeSong(){
        if let player=player{
                player.play()
                setTimer()
                btnPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    func loadMusic(){
        do{
            onStopSong()
            let url=URL(string:selectedSong!.getFile_path())
            let data = try Data(contentsOf: url!)
            player = try AVAudioPlayer(data: data)
            player!.prepareToPlay()
            onResumeSong()
        }catch{
            print("Loi phat nhac")
        }
    }
    
    func setTimer(){
        if let player=player{
            timer=Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ [self]_ in
                //Load lai giao dien khi ket thuc bai hat
                if !player.isPlaying && player.currentTime==0{
                    onPauseSong()
                }
                
                currentTime.text=Int(player.currentTime).convertSecondToMinute()
                endTime.text=Int(player.duration).convertSecondToMinute()
                progressBar.progress=Float(player.currentTime/player.duration)
            }
        }
        
    }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}
extension Int{
    func convertSecondToMinute()->String{
        let second=self%60
        let minute=self/60
        return String(format: "%d:%02d", minute,second)
    }
}
