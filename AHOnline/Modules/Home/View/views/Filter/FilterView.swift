//
//  FilterView.swift
//  AHOnline
//
//  Created by Ara Hakobyan on 7/9/16.
//  Copyright © 2016 AroHak LLC. All rights reserved.
//

enum SearchType: String {
    case Restaurant = "Restaurant"
    case Product    = "Product"
}

enum SortType: String {
    case Alphabet   = "Alphabet"
    case New        = "New"
    case Favorite   = "Favorite"
    case Best       = "Best"
}

class FilterView: UIView {
    
    private let cellIdentifire              = ["cellIdentifire1", "cellIdentifire2", "cellIdentifire3"]
    private let heights: [CGFloat]          = [SE_CELL_HEIGHT, SE_CELL_HEIGHT, SE_CELL_HEIGHT*4]
    private var selectedItems: [String]     = []
    private var headers: [String]           = []
    private var cellItems: [[String]]       = [[], [], []]
    private var collectionItems: [String]   = []
    private var cells: [[UITableViewCell]]  = []
    
    var cell: FilterCell!
    
    var searchType: SearchType {
        switch selectedItems[0] {
        case "Product":
            return .Product
        default:
            return .Restaurant
        }
    }
    
    var sort: String {
        return selectedItems[1]
    }
    
    var kitchens: [String] {
        return cell.cellContentView.selectedItems
    }
    
    //MARK: - Create UIElements -
    lazy var bgView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.alpha = 0.4
        
        return view
    }()
    
    lazy var footerView: UIView = {
        let view = UIView.newAutoLayoutView()
        view.backgroundColor = GREEN
        
        return view
    }()
    
    lazy var tableView: BaseTableView = {
        let view = BaseTableView.newAutoLayoutView()
        view.backgroundColor = WHITE
        view.alpha  = 0.9
        view.dataSource = self
        view.delegate = self
        view.layer.cornerRadius = SE_OFFSET/3
        view.clipsToBounds = true
        
        return view
    }()

    //MARK: - Initialize -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAllUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods -
    private func addAllUIElements() {
        addSubview(bgView)
        addSubview(tableView)

        setConstraints()
        
        configurationTableViewCell()
    }
    
    //MARK: - Public Methods -
    func setLocalizedStrings() {
        selectedItems       = ["restaurant".localizedString, "alphabet".localizedString]

        headers             = ["type".localizedString,
                               "sort".localizedString,
                               "kitchen".localizedString]
        
        cellItems           = [["restaurant".localizedString, "product".localizedString],
                               ["alphabet".localizedString, "new".localizedString, "favorite".localizedString, "best".localizedString],
                               [""]]
        
        collectionItems     = ["best_offer".localizedString,
                               "eastern".localizedString,
                               "european".localizedString,
                               "armenia".localizedString,
                               "georgian".localizedString,
                               "italian".localizedString,
                               "french".localizedString,
                               "greek".localizedString,
                               "american".localizedString,
                               "mexican".localizedString]
    }
    
    func configurationTableViewCell() {
        cells.removeAll()
        setLocalizedStrings()
        
        for i in 0..<headers.count {
            var temp: [UITableViewCell] = []
            for j in 0..<cellItems[i].count {
                if i == headers.count - 1 {
                    cell = FilterCell(style: .Default, reuseIdentifier: cellIdentifire[i])
                    cell.setValues(collectionItems)
                    temp.append(cell)
                    
                } else {
                    let cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifire[i])
                    cell.textLabel?.text = cellItems[i][j]
                    cell.textLabel?.font = TITLE_FONT
                    
                    if cellItems[i][j] == selectedItems[i]  {
                        cell.accessoryType = .Checkmark
                        cell.textLabel?.textColor = RED
                    } else {
                        cell.accessoryType = .None
                        cell.textLabel?.textColor = BLUE_LIGHT
                    }
                    temp.append(cell)
                }
            }
            cells.append(temp)
        }
        tableView.reloadData()
    }
    
    //MARK: - Constraints -
    func setConstraints() {
        let offset = SE_OFFSET*1.5
        bgView.autoPinEdgesToSuperviewEdges()
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: offset, bottom: offset, right: offset))
    }
}

//MARK: - extension for UITableView -
extension FilterView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cells[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return cells[indexPath.section][indexPath.row]
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return headers[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return heights[indexPath.section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            for cell in cells[0] {
                cell.accessoryType = .None
                cell.textLabel?.textColor = BLUE_LIGHT
            }
        case 1:
            for cell in cells[1] {
                cell.accessoryType = .None
                cell.textLabel?.textColor = BLUE_LIGHT
            }
        default:
            break
        }
        let cell = cells[indexPath.section][indexPath.row]
        cell.accessoryType = .Checkmark
        cell.textLabel?.textColor = RED
        selectedItems[indexPath.section] = cellItems[indexPath.section][indexPath.row]
    }
}
