//
//  CartViewController.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class CartViewController -
class CartViewController: BaseViewController {

    var output: CartViewOutput!

    var cartView = CartView()
    var cleaButtonItem: UIBarButtonItem!

    private let cellIdentifire      = ["cellIdentifire1", "cellIdentifire2", "cellIdentifire3"]
    private let headers             = ["ORDER", "DELIVERY", "PAYMENT"]
    private let heights: [CGFloat]  = [CA_CELL_HEIGHT, CA_CELL_HEIGHT*0.6, CA_CELL_HEIGHT*0.6]
    
    private var orders: [Product] = []
    
    private var deliveryCells: [DeliveryCell] = []
    private var titleDeliveries = ["Choose Address", "Choose City", "Choose Time"]
    private var deliveries: [Delivery] = []
    private var ordersTotalPrice = 0.0
    private var deliveryPrice = 0.0
    private var selectedIndex = 0
    private var selectedDate: NSDate!
    
    private var paymentCells: [UITableViewCell] = []
    private var titlePayments = ["Pay on delivery", "Credit Cart", "Paypal"]
    private var selectedPayment = "Pay on delivery"
    
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "Cart"
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addAction)), animated: true)
        cleaButtonItem = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: #selector(clearAction))
        navigationItem.rightBarButtonItems = [editButtonItem(), cleaButtonItem]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewIsReady()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillChangeFrameNotification)
    }
    
    // MARK: - Internal Method -
    override func baseConfig() {
        self.view = cartView
        
        cartView.tableView.dataSource = self
        cartView.tableView.delegate = self
        cartView.tableView.registerClass(OrderCell.self, forCellReuseIdentifier: cellIdentifire[0])
        
        configTableViewCell()
    }
    
    // MARK: - Private Method -
    private func configTableViewCell() {
        for title in titleDeliveries {
            let cell = DeliveryCell(style: .Default, reuseIdentifier: cellIdentifire[1])
            cell.cellContentView.titleLabel.text = title
            deliveryCells.append(cell)
        }
        
        for title in titlePayments {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifire[2])
            cell.backgroundColor = CLEAR
            cell.textLabel?.text = title
            cell.textLabel?.font = TITLE_FONT
            cell.accessoryType = title == selectedPayment ? .Checkmark : .None
            paymentCells.append(cell)
        }
    }
    
    //MARK: - Actions -
    func addAction() {
        output.addOrder()
    }
    
    func clearAction() {
        let alert =  UIAlertController(title: "Clear Cart", message: "Do you want to clear the cart", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel".localizedString, style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK".localizedString, style: .Default, handler: { _ in
            self.output.removeOrders(self.orders)
            self.orders.removeAll()
            self.hideView()
        }))
        
        output.presentViewController(alert)
    }
    
    //MARK: - Public Method -
    func hideView() {
        cartView.tableView.hidden = orders.count == 0
        cartView.footerView.hidden = cartView.tableView.hidden
        cartView.emptyView.hidden = !cartView.tableView.hidden
        cleaButtonItem.enabled = !cartView.tableView.hidden
        editButtonItem().enabled = !cartView.tableView.hidden
    }
    
    //MARK: - Keyboard notifications -
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber) as! NSTimeInterval
            let y = keyboardFrame.origin.y
            
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(animationDuration, animations: { _ in
                if ScreenSize.HEIGHT - y == 0 {
                    self.cartView.heightTableViewConstraint.constant = y - (NAV_HEIGHT + TAB_HEIGHT + CA_CELL_HEIGHT*1.5)
                } else {
                    self.cartView.heightTableViewConstraint.constant = y - (NAV_HEIGHT)
                }
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: - extension for CartViewInput -
extension CartViewController: CartViewInput {
    
    func deliveriesComing(deliveries: [Delivery]) {
        self.deliveries = deliveries
        
        deliveryCells[1].cellContentView.deliveryLabel.text = deliveries.first!.city
        deliveryCells[2].cellContentView.deliveryLabel.text = NSDate().deliveryTimeFormat
        
        deliveryPrice = deliveries.first!.price
        cartView.footerView.updateValues(ordersTotalPrice, delivery: deliveryPrice)
    }
    
    func ordersComing(orders: [Product], ordersPrice: Double) {
        self.orders = orders
        ordersTotalPrice = ordersPrice
        
        cartView.tableView.reloadData()
        cartView.footerView.updateValues(ordersTotalPrice, delivery: deliveryPrice)
        hideView()
    }
    
    func ordersTotalPrice(ordersPrice: Double) {
        ordersTotalPrice = ordersPrice
        cartView.footerView.updateValues(ordersTotalPrice, delivery: deliveryPrice)
    }
}

//MARK: - extension for UITableView -
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return headers.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orders.count
            
        case 1:
            return deliveryCells.count
            
        case 2:
            return paymentCells.count
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let order = orders[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifire[0]) as! OrderCell
            cell.cellContentView.textField.delegate = self
            cell.setValues(editing, product: order)

            return cell
        case 1:
            return deliveryCells[indexPath.row]

        case 2:
            return paymentCells[indexPath.row]
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return heights[indexPath.section]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headers[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 1:
                let actionSheet = DeliveryActionSheetPickerViewController(deliveries: deliveries) { delivery, index in
                    self.deliveryCells[indexPath.row].cellContentView.deliveryLabel.text = delivery.city
                    self.deliveryPrice = delivery.price
                    self.cartView.footerView.updateValues(self.ordersTotalPrice, delivery: self.deliveryPrice)
                    self.selectedIndex = index
                }
                actionSheet.pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
                
                output.presentViewController(actionSheet)
            case 2:
                let datePicker = DatePickerViewController(date: NSDate()) { date in
                    self.deliveryCells[indexPath.row].cellContentView.deliveryLabel.text = date.deliveryTimeFormat
                    self.selectedDate = date
                }
                if let date = selectedDate {
                    datePicker.pickerView.picker.setDate(date, animated: true)
                }
                
                output.presentViewController(datePicker)
            default:
                break
            }
            
        case 2:            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            for cell in paymentCells { cell.accessoryType = .None }
            paymentCells[indexPath.row].accessoryType = .Checkmark
            selectedPayment = titlePayments[indexPath.row]
            
        default:
            break
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? OrderCell
            
            if let cell = cell {
                let order = orders[indexPath.row]
                if !editing {
                    view.endEditing(true)

                    let count = cell.cellContentView.textField.text!.isEmpty ? 1 : Int(cell.cellContentView.textField.text!)!
                    output.updateOrder(order, count: count)
                }
                cell.cellContentView.updateValues(editing, product: order)
            }
        
            return true
            
        default:
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let order = orders[indexPath.row]
            output.removeOrder(order)
            
            orders.removeAtIndex(indexPath.row)
            cartView.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            hideView()
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .Delete
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        cartView.tableView.setEditing(editing, animated: animated)
    }
}

//MARK: - extension for UITextField -
extension CartViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString : String) -> Bool {
        
        return UIHelper.isValidCountTextField(textField, range: range, string: replacementString)
    }
}