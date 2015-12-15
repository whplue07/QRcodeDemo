//
//  ViewController.swift
//  QRcodeDemo
//
//  Created by Chieh-Chun Li on 2015/12/12.
//  Copyright © 2015年 Dan.Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //initial device with video type
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        //set device as input media
        var inputMedia : AnyObject!
        do
        {
            inputMedia = try AVCaptureDeviceInput.init(device: captureDevice)
            
        }catch let outError
        {
            print("something wrong with input : \(outError)")
            //alert
        }
        
        //init capture session
        captureSession = AVCaptureSession()
        captureSession?.addInput(inputMedia as! AVCaptureInput)
        //----------------------------------------------------------
        
        // init AVCatureMetadataOutput as the device fetching session's output data
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        //set delegate
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        //show in CALayer(previewlayer)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        //start to fetch vedio
        captureSession?.startRunning()
        
        //move message label to the top layer
        view.bringSubviewToFront(messageLabel)
        
        //init and reveals qrcode frame
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        
    }
    
    //handle output meta data
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        //print("qrcode is scanning...")
        if metadataObjects == nil || metadataObjects.count == 0
        {
            messageLabel.text = "No QRcode is detected"
            return
        }
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metaDataObject.type == AVMetadataObjectTypeQRCode
        {
            //messageLabel.text = "is detected"
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metaDataObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            if metaDataObject.stringValue != nil
            {
                messageLabel.text = metaDataObject.stringValue
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

