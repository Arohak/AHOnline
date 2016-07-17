//
//  ActionSheetPickerViewController.swift
//  AHMusic
//
//  Created by Ara Hakobyan on 5/19/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class ActionSheetPickerViewController: UIAlertController {

}

class DeliveryActionSheetPickerViewController: UIAlertController {
    
    var pickerView: DeliveryPickerView!
    
    init(deliveries: [Delivery], callback: DeliveryPickerCallback) {
        super.init(nibName: nil, bundle: nil)
        
        title = nil
        message = "\n\n\n\n\n\n"
        addAction(UIAlertAction(title: "close".localizedString, style: .Cancel) { _ in })
        
        pickerView = DeliveryPickerView(deliveries: deliveries, callback: callback)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pickerView)
        pickerView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        pickerView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 60)
        pickerView.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        pickerView.autoSetDimension(.Height, toSize: ScreenSize.HEIGHT*0.25)
    }
}