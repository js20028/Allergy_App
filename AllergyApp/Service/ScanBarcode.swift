//
//  ScanBarcode.swift
//  AllergyApp
//
//  Created by 김정태 on 2023/02/14.
//

import Foundation
import AVFoundation

class ScanBarcode {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession: AVCaptureSession?
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }
        
        return captureSession.isRunning
    }
    
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5, .qr]
    
    weak var delegate: ReaderViewDelegate?
    
    
    
    
}
