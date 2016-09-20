//
//  Tool.swift
//  QRCode
//
//  Created by gaofu on 16/9/9.
//  Copyright © 2016年 gaofu. All rights reserved.
//

import UIKit
import AudioToolbox

struct PhotoSource:OptionSet
{
    let rawValue:Int
    
    static let camera = PhotoSource(rawValue: 1)
    static let photoLibrary = PhotoSource(rawValue: 1<<1)
    
}


func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

typealias finishedImage = (_ image:UIImage) -> ()

class Tool: NSObject
{
    
    ///1.单例
    
    static let shareTool = Tool()
    private override init() {}
    
    var finishedImg : finishedImage?
    var isEditor = false
    
    
    
    ///2.选择图片
    
    func choosePicture(_ controller : UIViewController,  editor : Bool,options : PhotoSource = [.camera,.photoLibrary], finished : @escaping finishedImage)
    {
        
        finishedImg = finished
        isEditor = editor
        
        
        if options.contains(.camera) && options.contains(.photoLibrary)
        {
            let alertController = UIAlertController(title: "请选择图片", message: nil, preferredStyle: .actionSheet)
            
            let photographAction = UIAlertAction(title: "拍照", style: .default) { (_) in
                
                self.openCamera(controller: controller, editor: editor)
                
            }
            let photoAction = UIAlertAction(title: "从相册选取", style: .default) { (_) in
                
                self.openPhotoLibrary(controller: controller, editor: editor)
                
            }
            
            let cannelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(photographAction)
            alertController.addAction(photoAction)
            alertController.addAction(cannelAction)
            
            controller.present(alertController, animated: true, completion: nil)
            
            
        }
        else  if options.contains(.photoLibrary)
        {
            
            self.openPhotoLibrary(controller: controller, editor: editor)
            
        }
        else if options.contains(.camera)
        {
            
            self.openCamera(controller: controller, editor: editor)

        }
        
        
    }
    
    ///打开相册
    
    func openPhotoLibrary(controller : UIViewController,  editor : Bool)
    {
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        photo.allowsEditing = editor
        controller.present(photo, animated: true, completion: nil)
        
    }
    
    ///打开相机
    
    func openCamera(controller : UIViewController,  editor : Bool)
    {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = editor
        controller.present(photo, animated: true, completion: nil)
        
        
    }
    
    ///3.确认弹出框
    
    class func confirm(title:String?,message:String?,controller:UIViewController,handler: ( (UIAlertAction) -> Swift.Void)? = nil)
    {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let entureAction = UIAlertAction(title: "确定", style: .destructive, handler: handler)
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)

    }
    
    
    ///4.播放声音
    
    class func playAlertSound(sound:String)
    {
        
        guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil)  else { return }
        guard let soundUrl = NSURL(string: soundPath) else { return }

        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl, &soundID)
        AudioServicesPlaySystemSound(soundID)
        
    }

}


//MARK: -
//MARK:  Delegate

extension Tool : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        guard let image = info[isEditor ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else { return }
        picker.dismiss(animated: true) { [weak self] in
            guard let tmpFinishedImg = self?.finishedImg else { return }
            tmpFinishedImg(image)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
