//
//  ContuctUsInitializer.swift
//  AHOnline
//
//  Created by AroHak on 28/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class ContuctUsModuleInitializer {

    init(viewController: AnyObject) {
        let configurator = ContuctUsModuleConfigurator()
        configurator.configureModuleForController(viewInput: viewController)
    }
}
