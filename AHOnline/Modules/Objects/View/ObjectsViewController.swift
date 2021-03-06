//
//  ObjectsViewController.swift
//  AHOnline
//
//  Created by AroHak on 17/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

import SVPullToRefresh_Bell

enum ObjectsType: String {
    case ALL = "all"
    case New = "new"
    case Rate = "rate"
    case Open = "open"
}

//MARK: - class ObjectsViewController -
class ObjectsViewController: BaseViewController {

    var output: ObjectsViewOutput!

    private var objectsView         = ObjectsView()
    private let cellIdentifire      = "cellIdentifire"
    private var objects: [AHObject] = []
    
    private var search              = ""
    private var categoryID          = ""
    private var subcategoryID       = ""
    private var limit               = LIMIT
    private var offset              = OFFSET
    private var type                = ObjectsType.ALL
    
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "restaurants".localizedString
        navigationController?.setNavigationBarHidden(false, animated: false)
        getObjects()
    }
    
    //MARK: -  Internal Methods -
    override func baseConfig() {
        self.view = objectsView
        
        objectsView.tableView.dataSource = self
        objectsView.tableView.delegate = self
        objectsView.tableView.registerClass(ObjectsCell.self, forCellReuseIdentifier: cellIdentifire)
        objectsView.refresh.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        
        createPagination()
    }
    
    override func refresh() {
        offset = 0
        objectsView.tableView.showsInfiniteScrolling = true
        
        getObjects()
    }
    
    //MARK: -  Private Methods -
    private func getObjects() {
        var params = JSON.null
        if !categoryID.isEmpty {
            params = JSON([
                "category_id"       : "\(categoryID)",
                "subcategory_id"    : "\(subcategoryID)",
                "limit"             : "\(limit)",
                "offset"            : "\(offset)",
                "type"              : "\(type.rawValue)"])
            
        } else if !search.isEmpty {
            params = JSON([
                "limit"             : "\(limit)",
                "offset"            : "\(offset)",
                "search"            : "\(search)"])
            
        } else {
            params = JSON([
                "limit"             : "\(limit)",
                "offset"            : "\(offset)",
                "type"              : "\(type.rawValue)"])
        }
        
        output.getObjects(params)
    }
    
    //MARK: - Public Methods -
    func setParams(categoryID: String = "", subcategoryID: String = "", search: String = "", type: ObjectsType = .ALL) {
        self.categoryID     = categoryID
        self.subcategoryID  = subcategoryID
        self.search         = search
        self.type           = type
    }
    
    //MARK: - Pagination -
    func createPagination() {
        objectsView.tableView.addInfiniteScrollingWithActionHandler {
            [weak self] in
            if let weakSelf = self {
                weakSelf.offset += weakSelf.limit
                weakSelf.getObjects()
                weakSelf.objectsView.tableView.infiniteScrollingView.stopAnimating()
            }
        }
    }
}

//MARK: - extension for ObjectsViewInput -
extension ObjectsViewController: ObjectsViewInput {
    
    func updateObjectsData(objects: [AHObject]) {
        handleData(objects)
        objectsView.refresh.endRefreshing()
    }
    
    func handleData(newObjects: [AHObject]) {
        if offset == 0 {
            UIHelper.deleteRowsFromTable(objectsView.tableView, objects: &objects)
        }
        
        UIHelper.insertRowsInTable(objectsView.tableView, objects: newObjects, inObjects: &objects, reversable: false)
        objectsView.tableView.showsInfiniteScrolling = newObjects.count < limit ? false : true
    }
}

//MARK: - extension for UITableView -
extension ObjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifire) as! ObjectsCell
        let object = objects[indexPath.row]
        cell.setValues(object)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = objects[indexPath.row]
        output.didSelectObject(object)
    }
}

