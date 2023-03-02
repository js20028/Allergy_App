//
//  BarCodeView.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/14.
//

import Foundation
import UIKit
import AVFoundation

enum ReaderStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: AnyObject {
    func readerComplete(status: ReaderStatus)
}


class BarcodeView: UIView {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var centerGuideLineView: UIView?
    var captureSession: AVCaptureSession?
    
    var scanBarcode: ScanBarcode
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        
        return captureSession.isRunning
    }
    
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5, .qr]
    
    weak var delegate: ReaderViewDelegate?
    
    init(scanBarcode: ScanBarcode) {
        self.scanBarcode = scanBarcode
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override init(frame: CGRect) {
        self.scanBarcode = ScanBarcode()
        super.init(frame: frame)
        
        self.initialSetupView()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.scanBarcode = ScanBarcode()
        super.init(coder: aDecoder)
        self.initialSetupView()
    }
    
    
    
    private func initialSetupView() {
        self.clipsToBounds = true
        
        // AVCaptureSession 인스턴스 생성
        self.captureSession = AVCaptureSession()
        
        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }
        
        // 카메라를 이용하기 때문에 .video로 설정
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        // 지정된 장치를 사용하도록 입력을 초기화 하는 작업
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // 위에 만들어진 입력을 AVCaptureSession에 추가
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
        
        
        
        // 출력을 AVCaptureSession에 추가
        // 세션이 지정된 메타 데이터를 처리하기 위해 AVCaptureMetadataOutput를 출력으로 지정
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
        } else {
            self.fail()
            return
        }
        
        self.setPreviewLayer()
        self.setCenterGuideLineView()
    }
    
    
    
    
    private func setPreviewLayer() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds
        
        self.layer.addSublayer(previewLayer)
        
        self.previewLayer = previewLayer
    }
    
    
    
    
    private func setCenterGuideLineView() {
        let centerGuideLineView = UIView()
        centerGuideLineView.translatesAutoresizingMaskIntoConstraints = false
        centerGuideLineView.backgroundColor = #colorLiteral(red: 1, green: 0.5411764706, blue: 0.2392156863, alpha: 1)
        self.addSubview(centerGuideLineView)
        self.bringSubviewToFront(centerGuideLineView)
        
        centerGuideLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        centerGuideLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        centerGuideLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        centerGuideLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.centerGuideLineView = centerGuideLineView
    }
    
    
    
}


extension BarcodeView {
    func start() {
        print("start")
        
        DispatchQueue.global(qos: .background).async {
            // Call startRunning() method here
            self.captureSession?.startRunning()
        }
        
    }
    
    func stop(isButtonTap: Bool) {
        print("stop")
        self.captureSession?.stopRunning()

        self.delegate?.readerComplete(status: .stop(isButtonTap))
    }
    
    func fail() {
        print("fail")
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    // code: 바코드 번호
    func found(code: String) {
        print(code,"found")
        
        self.delegate?.readerComplete(status: .success(code))
    }
}


extension BarcodeView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        stop(isButtonTap: false)
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue else {
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
}
