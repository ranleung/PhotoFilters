//
//  AVFoundationCameraViewController.swift
//  PhotoFilters
//
//  Created by Randall Leung on 10/16/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//


import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class AVFoundationCameraViewController: UIViewController {
    
    @IBOutlet weak var capturePreviewImageView: UIImageView!
    
    var stillImageOutput = AVCaptureStillImageOutput()
    
    weak var delegate: PhotoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        self.capturePreviewImageView.addGestureRecognizer(tap)
        
        var captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        //Create a preview layer
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRectMake(0, 30, self.view.frame.size.width, CGFloat(self.view.frame.size.height * 0.7))
        self.view.layer.addSublayer(previewLayer)
        
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as AVCaptureDeviceInput!
        if input == nil {
            println("bad!")
        }
        captureSession.addInput(input)
        var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        self.stillImageOutput.outputSettings = outputSettings
        captureSession.addOutput(self.stillImageOutput)
        captureSession.startRunning()
    }
    
    @IBAction func capturePressed(sender: AnyObject) {
        
        var videoConnection : AVCaptureConnection?
        for connection in self.stillImageOutput.connections {
            if let cameraConnection = connection as? AVCaptureConnection {
                for port in cameraConnection.inputPorts {
                    if let videoPort = port as? AVCaptureInputPort {
                        if videoPort.mediaType == AVMediaTypeVideo {
                            videoConnection = cameraConnection
                            break;
                        }
                    }
                }
            }
            if videoConnection != nil {
                break;
            }
        }
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(buffer : CMSampleBuffer!, error : NSError!) -> Void in
            var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            var image = UIImage(data: data)
            self.capturePreviewImageView.image = image
            println(image.size)
        })
    }
    
    func tapAction(tap: UITapGestureRecognizer) {
        println("TAP GESTURE")
        self.delegate?.controller(self, didTapOnPicture: self.capturePreviewImageView.image)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
