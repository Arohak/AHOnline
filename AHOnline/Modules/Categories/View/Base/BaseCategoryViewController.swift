//
//  BaseCategoryViewController.swift
//  AHOnline
//
//  Created by AroHak on 09/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

class BaseCategoryViewController: BaseViewController {
    
    var output: CategoriesViewOutput!
    
    var baseCategoryView = BaseCategoryView()
    let cellIdentifire = "cellIdentifire"
    var category: Category!
    var subCategories: [SubCategory] = []
    
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -  Internal Methods -
    override func baseConfig() {
        self.view = baseCategoryView
        
        baseCategoryView.tableView.dataSource = self
        baseCategoryView.tableView.delegate = self
        baseCategoryView.tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: cellIdentifire)
    }
}

//MARK: - extension for UITableView -
extension BaseCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subCategories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifire) as! BaseTableViewCell
        let item = subCategories[indexPath.row]
        cell.imageView?.kf_setImageWithURL(NSURL(string: item.src)!, placeholderImage: Image(named: "img_all"))
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let subCategory = subCategories[indexPath.row]
        let json = JSON([
            "category_id"           : category.id,
            "subcategory_id"        : subCategory.id])
        
        output.didSelectRow(json)
    }
}
