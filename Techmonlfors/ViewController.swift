//
//  ViewController.swift
//  Techmonlfors
//
//  Created by 森田貴帆 on 2020/09/11.
//  Copyright © 2020 森田貴帆. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var cameraimageview:UIImageView!
    //編集する元画像
    var originalImage: UIImage!
    var filter:CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func takephoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }else{
            //かエメらが使えない時
            print("error")
        }
        
    }
    @IBAction func openalbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //カメラロールから画像選択して表紙するまで
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker,animated: true,completion: nil)
        }
    }
    @IBAction func share(){
        //投稿時に載せるコメント
        let shareText = "きほもりのアプリで画像加工した"
        //画像の選択
        let shareImage = cameraimageview.image!
        //投稿する画像と写真の準備
        let activityItems: [Any] = [shareText, shareImage]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func colorfilter(){
        let filterImage: CIImage = CIImage(image: originalImage)!
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKeyPath: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度
        filter.setValue(0.5, forKeyPath: "inputBrightness")
        //コントラスト
        filter.setValue(2.5, forKeyPath: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgimage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraimageview.image = UIImage(cgImage: cgimage!)
    }
    @IBAction func save(){
        UIImageWriteToSavedPhotosAlbum(cameraimageview.image!, nil,nil, nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraimageview.image = info[.editedImage] as? UIImage
        originalImage = cameraimageview.image//撮った写真を元画像として記録
        dismiss(animated: true, completion: nil)
    }





}

