//
//  ViewController.swift
//  WEPicker
//
//  Created by 梦烙时光 on 2018/1/10.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBAction func click(_ sender: UIButton) {
        
        let picker = WEPickerViewController.nibViewController()
        picker.sourceView = sender
        picker.sourceRect = sender.bounds
        picker.showTitle = "选择"
        picker.bottomBarColor = .black
        picker.currentLeftText = "号"
        picker.currentRightText = "房间"
        picker.handle = {
            print("\($0): \($1)")
        }
        picker.datas = [
            "1": ["1","2","3"],
            "2": ["1","2"],
            "3": ["1","2","3","4","5"],
            "4": ["1","2","3","4"],
            "5": ["1","2"]
        ]
        present(picker, animated: true)
    }
    

}

