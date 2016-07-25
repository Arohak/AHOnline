//
//  FilterCollectionCell.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class FilterCollectionCell: UICollectionViewCell {
    
    //MARK: - Create UIElements -
    var cellContentView = FilterCollectionCellContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellContentView)
        cellContentView.autoPinEdgesToSuperviewEdges()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - FilterCollectionCellContentView -
class FilterCollectionCellContentView: UIView {
    
    //MARK: - Create UIElements -
    lazy var button: HOButton = {
        let view = HOButton.newAutoLayoutView()
        view.setTitleColor(WHITE, forState: .Normal)
        view.titleLabel?.font = CA_TITLE_FONT
        view.setBackgroundImage(UIImage(named: "img_result"), forState: .Normal)
        view.setBackgroundImage(UIImage(named: "img_result_select"), forState: .Selected)
        view.userInteractionEnabled = false
        
        return view
    }()
    
    //MARK: - Initialize -
    init() {
        super.init(frame: CGRectZero)
        
        addAllUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods -
    private func addAllUIElements() {
        addSubview(button)
        
        setConstraints()
    }
    
    //MARK: - Constraints -
    func setConstraints() {
        button.autoPinEdgesToSuperviewEdges()
    }
}

