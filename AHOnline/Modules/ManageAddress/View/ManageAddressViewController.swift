//
//  ManageAddressViewController.swift
//  AHOnline
//
//  Created by AroHak on 28/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class ManageAddressViewController -
class ManageAddressViewController: UIViewController {

    var output: ManageAddressViewOutput!
    
    private var manageAddressView                   = ManageAddressView()
    private var countries: [String]                 = []
    private var citiesTuple: [(String, String)]     = []
    private var selectedCountry                     = ""
    private var selectedCity                        = ""
    private var selectedAlias                       = ""
    private var selectedAddress                     = ""
    
    private var user: User?
    
    private var cities: [String] {
        var temp = [String]()
        for item in citiesTuple { temp.append(item.0) }
        
        return temp
    }

    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "delivery_address".localizedString
        navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "close".localizedString, style: .Plain, target: self, action: #selector(closeAction)), animated: true)
        
        output.viewIsReady()
        baseConfig()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        manageAddressView.addressFieldView.textField.becomeFirstResponder()
    }
    
    // MARK: - Private Method -
    private func baseConfig() {
        self.view = manageAddressView
        
        manageAddressView.cityFieldView.textField.delegate = self
        manageAddressView.addressFieldView.textField.delegate = self
        manageAddressView.countryView.button.addTarget(self, action: #selector(countryButtonAction), forControlEvents: .TouchUpInside)
        manageAddressView.cityView.button.addTarget(self, action: #selector(cityButtonAction), forControlEvents: .TouchUpInside)
        manageAddressView.saveButton.addTarget(self, action: #selector(saveButtonAction), forControlEvents: .TouchUpInside)
    }
    
    private func updateView() {
        manageAddressView.cityView.hidden = !(selectedCountry == "Armenia" && cities.count > 0)
        manageAddressView.cityFieldView.hidden = !manageAddressView.cityView.hidden
        manageAddressView.cityFieldView.setValue("")
    }
    
    private func isValidInputParams() -> Bool {
        var isValid = true
        if manageAddressView.cityView.hidden {
            if !UIHelper.isValidTextField(manageAddressView.cityFieldView.textField) { isValid = false }
        }
        if !UIHelper.isValidTextField(manageAddressView.addressFieldView.textField) { isValid = false }
        
        return isValid
    }
    
    //MARK: - Actions -
    func closeAction() {
        output.closeButtonClicked()
    }
    
    func countryButtonAction() {
        let actionSheet = ActionSheetPickerViewController(values: countries) { value in
            self.manageAddressView.countryView.setValue(value)
            self.selectedCountry = value
            self.updateView()
        }
        actionSheet.pickerView.selectRow(countries.indexOf(selectedCountry)!, inComponent: 0, animated: true)
        
        output.presentViewController(actionSheet)
    }
    
    func cityButtonAction() {
        let actionSheet = ManageAddressActionSheetPickerViewController(values: citiesTuple) { value in
            self.manageAddressView.cityView.setValue(value.0)
            self.selectedCity = value.0
            self.selectedAlias = value.1
        }
        if cities.count > 0 {
            let index = cities.indexOf(selectedCity) != nil ? cities.indexOf(selectedCity)! : 0
            actionSheet.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        output.presentViewController(actionSheet)
    }
    
    func saveButtonAction() {
        if isValidInputParams() {
            let json = JSON([
                "country"   : manageAddressView.countryView.titleLabel.text!,
                "city"      : manageAddressView.cityView.hidden ? manageAddressView.cityFieldView.textField.text! : manageAddressView.cityView.titleLabel.text!,
                "alias"     : manageAddressView.cityView.hidden ? "" : selectedAlias,
                "address"   : manageAddressView.addressFieldView.textField.text!]
            )
            
            output.saveButtonClicked(json)
        }
    }
}

//MARK: - extension for ManageAddressViewInput -
extension ManageAddressViewController: ManageAddressViewInput {
    
    func setupInitialState(user: User?, countries: [String], citiesTuple: [(String, String)]) {
        self.user = user
        self.countries = countries
        self.citiesTuple = citiesTuple
        
        if let address = user?.address {
            selectedCountry = address.country
            selectedCity = address.city
            selectedAlias = address.alias
            selectedAddress = address.add
        } else {
            selectedCountry = "Armenia"
          if cities.count > 0 {
            selectedCity = citiesTuple.first!.0
            selectedAlias = citiesTuple.first!.1
            }
        }
        
        manageAddressView.countryView.setValue(selectedCountry)
        manageAddressView.cityView.setValue(selectedCity)
        manageAddressView.addressFieldView.setValue(selectedAddress)
        
        updateView()
    }
}

//MARK: - extension for UITextFieldDelegate -
extension ManageAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case manageAddressView.cityFieldView.textField:
            manageAddressView.addressFieldView.textField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

