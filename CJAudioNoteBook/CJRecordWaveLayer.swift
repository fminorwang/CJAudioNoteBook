//
//  CJRecordWaveLayer.swift
//  CJAudioNoteBook
//
//  Created by fminor on 17/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import UIKit

private let POINT_COUNT = 400
private let IMPULSE_INTERVAL = 0.2

private let TEXT_LABEL_HEIGHT = CGFloat(40.0)

/**
 显示波浪形音量
 通过正弦函数与固定两端点的贝塞尔曲线相乘得到波形音量图形
 */
class CJRecordWaveLayer: CJBaseRecordVolumeLayer {
    
    fileprivate var _isRecording = false
    
    fileprivate var _displayLink: CADisplayLink?
    fileprivate var _emptyDataTimer: Timer?
    fileprivate var _recordTimer: Timer?
    fileprivate var _time = 0.0
    
    fileprivate var _impulseArr = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    fileprivate var _impulseTime = 0.0
    
    fileprivate let _timeLayer = CATextLayer()
    fileprivate var _recordedSeconds = 0
    
    override init() {
        super.init()
        self.masksToBounds = false
        
        _timeLayer.opacity = 0.0
        _timeLayer.foregroundColor = UIColor.theme.cgColor
        _timeLayer.font = UIFont.hint
        _timeLayer.contentsScale = UIScreen.main.scale
        _timeLayer.alignmentMode = kCAAlignmentCenter
        _timeLayer.masksToBounds = false
        self.addSublayer(_timeLayer)
        
        _displayLink = CADisplayLink(target: self, selector: #selector(_update))
        _displayLink?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        _startEqueueEmptyData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        _timeLayer.frame = CGRect(x: 0,
                                  y: self.bounds.height - TEXT_LABEL_HEIGHT,
                                  width: self.bounds.width,
                                  height: TEXT_LABEL_HEIGHT)
    }
    
    override func volumeChanged(to value: Float) {
        _impulseArr.insert(Double(value).volumeRatio * 40.0, at: 0)
        _impulseArr.removeLast()
        _impulseTime = 0.0
    }
    
    override func startRecording() {
        _isRecording = true
        _startRecordingTime()
        _stopEqueueEmptyData()
    }
    
    override func stopRecording() {
        _isRecording = false
        _stopRecordingTime()
        _startEqueueEmptyData()
    }
}

// MARK: 录音事件
extension CJRecordWaveLayer {
    
    fileprivate func _startEqueueEmptyData() {
        _stopEqueueEmptyData()
        _emptyDataTimer = Timer.scheduledTimer(timeInterval: IMPULSE_INTERVAL,
                                               target: self, selector: #selector(_enqueueEmptyData),
                                               userInfo: nil, repeats: true)
    }
    
    fileprivate func _stopEqueueEmptyData() {
        _emptyDataTimer?.invalidate()
        _emptyDataTimer = nil
    }
    
    private dynamic func _enqueueEmptyData() {
        _impulseArr.insert(0.0, at: 0)
        _impulseArr.removeLast()
        _impulseTime = 0.0
    }
    
    fileprivate func _startRecordingTime() {
        _stopRecordingTime()
        _recordedSeconds = 0
        _recordTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                            target: self, selector: #selector(_actionUpdateRecordingTime),
                                            userInfo: nil, repeats: true)
        _timeLayer.opacity = 1.0
        _renderTime()
    }
    
    fileprivate func _stopRecordingTime() {
        _recordTimer?.invalidate()
        _recordTimer = nil
        _timeLayer.opacity = 0.0
    }
    
    private dynamic func _actionUpdateRecordingTime() {
        _recordedSeconds = _recordedSeconds + 1;
        _renderTime()
    }
    
    private func _renderTime() {
        _timeLayer.string = _recordedSeconds.recordingTime
    }
}

// MARK: 画图
extension CJRecordWaveLayer {
    
    fileprivate dynamic func _update() {
        _time += 1.0 / 60.0
        _impulseTime += 1.0 / 60.0
        self.setNeedsDisplay()
    }
    
    override func draw(in ctx: CGContext) {
        
        // y(x) = A(x) * sin(wx - b * time)
        
        // A(t) = x0 * (1-t)^3 + 3 * x1 * t(1-t)^2 + 3 * x2 * t^2(1-t) + x3 * t^3
        
        let _width = self.bounds.width
        let _height = self.bounds.height
        
        let (_impulse1, _impulse2) = _computeImpuseResponse()
        
        let p0 = CGPoint(x: 0.0, y: 0.0)
        let p1 = CGPoint(x: _width / 2 - 50.0, y: CGFloat(_impulse1))
        let p2 = CGPoint(x: _width / 2 + 50.0, y: CGFloat(_impulse2))
        let p3 = CGPoint(x: _width, y: 0.0)
        
        let b = 15.0
        let w = 0.03
        
        ctx.setStrokeColor(UIColor.theme.cgColor)
        ctx.setLineWidth(0.5)
        ctx.move(to: CGPoint(x: 0.0, y: _height / 2))
        for i in 0..<POINT_COUNT {
            let _t = 1.0 * Double(i) / Double(POINT_COUNT)
            let _t_2 = _t * _t
            let _t_3 = _t * _t * _t
            let _1_t = 1.0 - _t
            let _1_t_2 = _1_t * _1_t
            let _1_t_3 = _1_t * _1_t * _1_t
            let _exp0 = _1_t_3
            let _exp1 = _1_t_2 * _t
            let _exp2 = _1_t * _t_2
            let _exp3 = _t_3
            
            let A = { (t0: Double, t1: Double, t2: Double, t3: Double) -> Double in
                var _result = t0 * _exp0
                _result += 3 * t1 * _exp1
                _result += 3 * t2 * _exp2
                _result += t3 * _exp3
                return _result
            }
            
            let _x = CGFloat(A(Double(p0.x), Double(p1.x), Double(p2.x), Double(p3.x)))
            let _A = A(Double(p0.y), Double(p1.y), Double(p2.y), Double(p3.y))
            let _y = CGFloat(Double(_A) * sin(w * Double(_x) - b * Double(_time))) + _height / 2.0
            ctx.addLine(to: CGPoint(x: _x, y: _y))
        }
        ctx.strokePath()
    }
    
    fileprivate func _computeImpuseResponse() -> (Double, Double) {
        // eff = sigma(impulse * sin(pi/T * t))
        var _v0 = 0.0
        var _v1 = 0.0
        let _w = M_PI / ( IMPULSE_INTERVAL * 4 )
        for i in 0...3 {
            let _impulse0 = _impulseArr[i]
            let _impulse1 = _impulseArr[i + 2]
            let _t = _impulseTime + Double(i) * IMPULSE_INTERVAL
            _v0 += _impulse0 * sin(_w * _t)
            _v1 += _impulse1 * sin(_w * _t)
        }
        let _maxHeight = Double(self.bounds.height / 2.0)
        _v0 = min(_v0, _maxHeight)
        _v1 = min(_v1, _maxHeight)
        return (_v0, _v1)
    }
    
}
