//
//  WEPickerView.swift
//  WEPicker
//
//  Created by 梦烙时光 on 2018/1/10.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

class WEPickerView: UIPickerView
{

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.subviews.count > 2 {
            _ = [1,2].map { subviews[$0].backgroundColor = .clear }
        }
    }
    

}
