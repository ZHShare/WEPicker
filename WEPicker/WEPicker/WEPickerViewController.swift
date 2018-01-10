//
//  WEPickerViewController.swift
//  WEPicker
//
//  Created by 梦烙时光 on 2018/1/10.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

fileprivate enum PickerViewTag: Int {
    case left = 1001
    case right
}

struct WEButton {
    let title: String
    let normalColor: UIColor
    let fontSize: CGFloat
    
    static var cancel: WEButton {
        return WEButton(title: "取消", normalColor: UIColor.darkGray, fontSize: 14)
    }
    
    static var sure: WEButton {
        return WEButton(title: "确定", normalColor: UIColor.blue, fontSize: 14)
    }
}

class WEPickerViewController: UIViewController
{
    var handle: ((Int,Int) -> Swift.Void)?
    var datas: [String: [String]]! {
        didSet { updateUI() }
    }
    var sourceView: UIView? {
        didSet { popoverPresentationController?.sourceView = sourceView }
    }
    var sourceRect: CGRect = CGRect.zero {
        didSet { popoverPresentationController?.sourceRect = sourceRect }
    }
    var showTitle: String? { // 标题
        didSet { updateUI() }
    }
    var showTitleBgColor: UIColor = UIColor.groupTableViewBackground { // 标题栏背景色
        didSet { updateUI() }
    }
    var currentLeftText: String = "栋" {
        didSet { updateUI() }
    }
    var currentRightText: String = "层" {
        didSet { updateUI() }
    }
    var bottomBarColor: UIColor  = UIColor.lightGray  { // 底部栏背景色
        didSet { updateUI() }
    }
    var currentLineBgColor: UIColor = UIColor.groupTableViewBackground  {
        didSet { updateUI() } // 展示条背景色
    }
    
    var currentLineTintColor: UIColor = UIColor.blue { // 当前文字颜色
        didSet { updateUI() }
    }
    
    var cancelButtonSetting: WEButton = WEButton.cancel { // 取消按钮设置
        didSet { updateUI() }
    }
    var sureButtonSetting: WEButton = WEButton.sure { // 确定按钮设置
        didSet { updateUI() }
    }
    
    
    fileprivate struct Constant {
        
        static let poperWidth: CGFloat = 320
    }
    
    fileprivate var leftSelectedRow = 0
    fileprivate var rightSelectedRow = 0
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var bottomBarTopLine: UIView!
    @IBOutlet var sureButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var bottomBar: UIView!
    @IBOutlet var bar: UIView!
    @IBOutlet var currentLineBg: UIView!
    @IBOutlet var displayTitle: UILabel!
    @IBAction func cancel(_ sender: UIButton?) {
        dismiss(animated: true)
    }
    
    @IBAction func sure(_ sender: UIButton) {
        cancel(nil)
        handle?(leftSelectedRow,rightSelectedRow)
    }
    
    @IBOutlet var leftPickerView: WEPickerView!
    @IBOutlet var rightPickerView: WEPickerView!
    
    static func nibViewController() -> WEPickerViewController {
        let picker = WEPickerViewController(nibName: "WEPickerViewController", bundle: nil)
        picker.modalPresentationStyle = .popover
        if let poper = picker.popoverPresentationController {
            poper.delegate = picker
        }
        return picker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    fileprivate func updateUI() {
        leftPickerView?.reloadAllComponents()
        rightPickerView?.reloadComponent(0)
        displayTitle?.text = showTitle
        
        bar?.backgroundColor = showTitleBgColor
        currentLineBg?.backgroundColor = currentLineBgColor
        leftLabel?.textColor = currentLineTintColor
        rightLabel?.textColor = currentLineTintColor
        bottomBar?.backgroundColor = bottomBarColor
        bottomBarTopLine?.backgroundColor = bottomBarColor
        cancelButton?.setTitle(cancelButtonSetting.title, for: .normal)
        cancelButton?.setTitleColor(cancelButtonSetting.normalColor, for: .normal)
        cancelButton?.titleLabel?.font = UIFont.systemFont(ofSize: cancelButtonSetting.fontSize)
        
        sureButton?.setTitle(sureButtonSetting.title, for: .normal)
        sureButton?.setTitleColor(sureButtonSetting.normalColor, for: .normal)
        sureButton?.titleLabel?.font = UIFont.systemFont(ofSize: sureButtonSetting.fontSize)
        
        leftLabel?.text = currentLeftText
        rightLabel?.text = currentRightText
    }
}
extension WEPickerViewController: UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension WEPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == PickerViewTag.left.rawValue ? datas == nil ? 0 : Array(datas).count : Array(datas)[leftSelectedRow].value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == PickerViewTag.left.rawValue ? (datas == nil ? "" : Array(datas)[row].key) : (datas == nil ? "" : Array(datas)[leftSelectedRow].value[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {        
        if pickerView.tag == PickerViewTag.left.rawValue {
            leftSelectedRow = row
            rightSelectedRow = 0
            pickerView.selectRow(row, inComponent: component, animated: true)
            leftPickerView.reloadAllComponents()
            self.pickerView(rightPickerView, didSelectRow: rightSelectedRow, inComponent: component)
           
        }
        else {
            rightSelectedRow = row
            pickerView.selectRow(row, inComponent: component, animated: true)
            rightPickerView.reloadAllComponents()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.minimumScaleFactor = 0.5
            pickerLabel?.adjustsFontSizeToFitWidth = true
            pickerLabel?.textAlignment = .center
        }
        
        let title = pickerView.tag == PickerViewTag.left.rawValue ? Array(datas)[row].key : Array(datas)[leftSelectedRow].value[row]
        
        if pickerView.tag == PickerViewTag.left.rawValue {
            if row == self.leftSelectedRow {
                pickerLabel?.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor : currentLineTintColor])
            }
            else {
                let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
                pickerLabel?.text = title
            }
        }
        else {
          
            if row == self.rightSelectedRow {
                pickerLabel?.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor : currentLineTintColor])
            }
            else {
                let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
                pickerLabel?.text = title
            }
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
