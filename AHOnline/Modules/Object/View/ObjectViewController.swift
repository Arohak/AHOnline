//
//  ObjectViewController.swift
//  AHOnline
//
//  Created by AroHak on 17/07/2016.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

//MARK: - class ObjectViewController -
class ObjectViewController: BaseViewController {

    var output: ObjectViewOutput!

    private var objectView: ObjectView!
    private let cellIdentifire = "cellIdentifire"
    private var object: AHObject!
    
    //MARK: - Initilize -
    init(object: AHObject) {
        super.init(nibName: nil, bundle: nil)
        
        title = object.label
        objectView = ObjectView(object: object, headerRect: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: ScreenSize.HEIGHT*0.3))
        self.object = object
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let headerView = objectView.tableView.tableHeaderView as! ParallaxHeaderView
        headerView.refreshBlurViewForNewImage()
    }
    
    //MARK: -  Internal Methods -
    override func baseConfig() {
        self.view = objectView
        
        objectView.tableView.dataSource = self
        objectView.tableView.delegate = self
        objectView.tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: cellIdentifire)
    }
}

//MARK: - extension for ObjectViewInput -
extension ObjectViewController: ObjectViewInput {
    
    func setupInitialState() {
        
    }
}

//MARK: - extension for UITableView -
extension ObjectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return object.menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifire) as! BaseTableViewCell
        let objectCategory = object.menus[indexPath.row]
        cell.textLabel?.text = objectCategory.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let objectMenu = object.menus[indexPath.row]
        output.didSelectObjectMenuRow(objectMenu)
    }
}

//MARK: - extension for UIScrollView -
extension ObjectViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == objectView.tableView {
            if let parallaxHeaderView = objectView.tableView.tableHeaderView as? ParallaxHeaderView {
                parallaxHeaderView.headerViewForScrollViewOffset(scrollView.contentOffset)
            }
        }
    }
}
