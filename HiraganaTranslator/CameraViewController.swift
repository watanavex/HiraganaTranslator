//
//  CameraViewController.swift
//  HiraganaTranslator
//
//  Created by C02W61D9HV2H on 2020/01/21.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation
import TesseractOCR

struct CameraSourceError: Error {
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var captureSession: AVCaptureSession?
    private var captureOutput: AVCaptureVideoDataOutput?
    private var device: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AVCaptureDevice.rx.requestAccess()
            .andThen(Single<(AVCaptureDevice, AVCaptureSession, AVCaptureVideoDataOutput)>.deferred {
                let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
                guard let device = deviceDiscoverySession.devices.first else {
                    throw CameraSourceError()
                }
                self.device = device
                
                let captureSession = AVCaptureSession()
                captureSession.sessionPreset = .medium
                
                let captureOutput = AVCaptureVideoDataOutput()
                captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
                captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
                captureOutput.alwaysDiscardsLateVideoFrames = true
                
                let captureDeviceInput = try AVCaptureDeviceInput(device: device)
                captureSession.addInput(captureDeviceInput)
                captureSession.addOutput(captureOutput)
                
                return Single.just((device, captureSession, captureOutput))
            })
            .observeOn(MainScheduler.instance)
            .do(onSuccess: { [weak self] (_, captureSession, captureOutput) in
                captureSession.startRunning()
                self?.captureSession = captureSession
                self?.captureOutput = captureOutput
            })
            .subscribe(
                onSuccess: { (device, session, captureOutput) in
                    let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                    videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    videoPreviewLayer.connection?.videoOrientation = .portrait
                    videoPreviewLayer.frame = UIScreen.main.bounds
                    self.view.layer.addSublayer(videoPreviewLayer)
                    session.startRunning()
                }
            )
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        var ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        let ciFilter = CIFilter(name: "CIColorControls")!
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        ciFilter.setValue(0, forKey: kCIInputSaturationKey)
        ciImage = ciFilter.outputImage!
        
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        
        let tesseract = G8Tesseract(language: "jpn")
        tesseract?.image = UIImage(cgImage: cgImage)
        print("\"", tesseract?.recognizedText ?? "nil", "\"")
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



struct AVCaptureDeviceAuthorizationError: Error {
}

extension Reactive where Base == AVCaptureDevice {
    
    static func requestAccess() -> Completable {
        return Completable.create { emitter in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    return emitter(.completed)
                }
                else {
                    return emitter(.error(AVCaptureDeviceAuthorizationError()))
                }
            }
            
            return Disposables.create()
        }
    }
    
}
