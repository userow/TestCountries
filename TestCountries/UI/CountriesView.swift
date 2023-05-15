//
//  CountriesView.swift
//  TestCountries
//
//  Created by John Doe on 24.04.2023.
//

import UIKit

// TODO: Implement

public let kAnimationDuration = 0.3

class CountriesView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	// MARK: - Declarations. Private
    private var _isSearching = true //false

	private var _searchText: String? = nil
    private var _isFlaggOn = false
    private var _isCodeOn = false

    private var _currentCountries = [CountryInfo]()

    // MARK: subviews
	private let _navigationItem = UINavigationItem()
	private let _navigationBar = UINavigationBar()
	private let _buttonSearch = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
	
	private let _searchBar = UISearchBar()
	
	private let _tableView = UITableView(frame: .zero, style: .plain)
	
	private let _toolBar = UIToolbar()
	private var _buttonFlag = UIBarButtonItem()
    private let _spacer = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16)))
    private var _buttonCode = UIBarButtonItem()
    private let _spacerFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let _labelToolbar = UILabel()
    private var _labelToolbarItem = UIBarButtonItem()

	// MARK: - Initialize
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.white
		
		_navigationItem.title = "Countries"
		_navigationItem.rightBarButtonItem = _buttonSearch
		_navigationBar.pushItem(_navigationItem, animated: false)
		
		_buttonSearch.target = self
		_buttonSearch.action = #selector(onButtonSearchDidTap)
		
		_searchBar.showsCancelButton = true
		_searchBar.delegate = self
		_searchBar.isHidden = !_isSearching
		
		_tableView.rowHeight = UITableView.automaticDimension
		_tableView.estimatedRowHeight = 64.0
		_tableView.dataSource = self
		_tableView.delegate = self
        _tableView.register(CountryCellView.self, forCellReuseIdentifier: CountryCellView.cellReuseId)
		
		self.addSubview(_tableView)
		self.addSubview(_searchBar)
		self.addSubview(_navigationBar)

//        if #available(iOS 15.0, *) {
//            self.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: _tableView.bottomAnchor, multiplier: 1.0).isActive = true
//        } else {
//            // Fallback on earlier versions
//        }
        //TODO: as constraint works only > 15.0 - use old bad KB Notifications.

		_buttonFlag = UIBarButtonItem(image: UIImage(systemName: "flag"), style: .plain, target: self, action: #selector(onButtonFlagDidTap))
        _buttonCode = UIBarButtonItem(image: UIImage(systemName: "number.square"), style: .plain, target: self, action: #selector(onButtonCodeDidTap))
        _labelToolbarItem = UIBarButtonItem(customView: _labelToolbar)
        _labelToolbar.text = "250 of 250"
		_toolBar.items = [_buttonFlag, _spacer, _buttonCode, _spacerFlexible, _labelToolbarItem]

		self.addSubview(_toolBar)

        _initDataSource()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Private

    private func _initDataSource() {
        _currentCountries = CountriesList.shared.orderedCountries
    }

    private func _currentState() -> CountryCellState {
        return CountryCellState(isFlagOn: _isFlaggOn, isCodeOn: _isCodeOn, highlightedText: _searchText ?? "")
    }

	private func setIsSearching(_ isSearching: Bool, animated: Bool) {
        _isSearching = isSearching
        print("isSearching = \(isSearching)")

        let navbarFrame = _navigationBar.frame

        var nextSearchBarFrame = _searchBar.frame
        var nextSbAlpha = 0.0
        var nextTableViewFrame = _tableView.frame
        //move _table top part, activate | deactivate first responder.

        if _isSearching {
            nextSearchBarFrame.origin.y = navbarFrame.maxY
            nextTableViewFrame.origin.y = nextSearchBarFrame.maxY
            nextTableViewFrame.size.height = nextTableViewFrame.height + nextSearchBarFrame.height
            nextSbAlpha = 1.0
            _searchBar.becomeFirstResponder()
        } else {
            nextSearchBarFrame.origin.y = navbarFrame.maxY - nextSearchBarFrame.height
            nextTableViewFrame.origin.y = navbarFrame.maxY
            nextTableViewFrame.size.height = nextTableViewFrame.height - nextSearchBarFrame.height
            nextSbAlpha = 0.0
            _searchBar.resignFirstResponder()
        }
        let changes = {
            self._searchBar.frame = nextSearchBarFrame
            self._tableView.frame = nextTableViewFrame
            self._searchBar.alpha = nextSbAlpha
        }
        //TODO: ??? change tableView heigh in responce to keyboard apperance - wasn't shown in video
        if animated {
            let propAnimator = UIViewPropertyAnimator(duration: kAnimationDuration, curve: .easeInOut) {
                changes()
            }
            propAnimator.startAnimation()
        } else {
            changes()
        }

        self.setNeedsLayout()
	}
    /**
     вводная:

     есть:
     - orderedCountries
     - searchText
     в случае второй и далее фильтраций (ввод A -> As -> Ask -> As) - есть предыдущий результат

     нужно:
     - (ввести локальную переменную currentCountries),
     + получить новый dataSource - nextCountries [CountryInfo],
     - по новому и старому dataSource получить массивы индексов [IndexPath] для использования в tableView.performBatchUpdates - add, remove, ? update (все остальные)
     - задать новый dataSource вместо старого
     - запустить tableView.performBatchUpdates
     */
    private func _setSearchText(_ searchText: String?) {
        if let text = searchText {
            _searchText = text

            if text.count > 0 {
                let nextCountries = CountriesList.shared.filterCountries(state: _currentState())

                if nextCountries.count > 0 {
                    //TODO: calculate indexes of filtering out
                    let indexes = CountriesList.shared.findIndexesOfAddedAndRemovedObjects(currentCountries: _currentCountries,
                                                                                           nextCountries: nextCountries)
                    // implement saving of data
                    _currentCountries = nextCountries

                    _tableView.performBatchUpdates({
                        //TODO: batch delete
                        _tableView.deleteRows(at: indexes.removedIndexes, with: .fade)
                        _tableView.insertRows(at: indexes.addedIndexes, with: .fade)
                    }) //, completion: { animationFinishedSuccessfully /*Bool*/ in
  //                  })
                    _updateCount()
                } else {
                    //TODO: ??? show empty view ? show empty table ? -  - wasn't shown in video
                }
            } else {
                //let nextCountries = CountriesList.shared.orderedCountries

                // visible index paths + 1
                //_tableView.performBatchUpdates({
//                _tableView.reloadRows(at: [IndexPath](), with: .fade)
            }
        }
	}

//    func updateSearchResults(for searchController: UISearchController) {
//        let searchText = searchController.searchBar.text ?? ""
//        filteredData = originalData.filter { $0.localizedCaseInsensitiveContains(searchText) }
//        tableView.performBatchUpdates({
//            if filteredData.isEmpty {
//                tableView.deleteSections([0], with: .fade)
//            } else if originalData.count == filteredData.count {
//                tableView.insertSections([0], with: .fade)
//            } else {
//                tableView.reloadSections([0], with: .fade)
//            }
//        }, completion: nil)
//    }

    private func _updateCount() {
        let current = _currentCountries.count
        let total = CountriesList.shared.orderedCountries.count

        if (current != total) {
            _labelToolbar.text = "\(current) of \(total)"
        } else {
            _labelToolbar.text = ""
        }
    }
	
	// MARK: - Layout
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let rcBnds = self.bounds
		let rcCont = rcBnds.inset(by: self.safeAreaInsets)
		
		var rcNavBar = rcBnds
		rcNavBar.origin.y = rcCont.origin.y
		rcNavBar.size.height = _navigationBar.sizeThatFits(rcNavBar.size).height
		
		var rcSrcBar = rcBnds
		rcSrcBar.size.height = _searchBar.sizeThatFits(rcSrcBar.size).height

        if _isSearching {
			rcSrcBar.origin.y = rcNavBar.maxY
		} else {
			rcSrcBar.origin.y = rcNavBar.maxY - rcSrcBar.size.height
		}
		
		var rcToolBar = rcBnds
		rcToolBar.size.height = _toolBar.sizeThatFits(rcToolBar.size).height
		rcToolBar.origin.y = rcCont.maxY - rcToolBar.size.height
		
		var rcTable = rcBnds
		rcTable.origin.y = rcSrcBar.maxY
		rcTable.size.height = rcToolBar.origin.y - rcTable.origin.y
		
		_navigationBar.frame = rcNavBar
		_searchBar.frame = rcSrcBar
		_tableView.frame = rcTable
		_toolBar.frame = rcToolBar
	}
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _currentCountries.count
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countryInfo = _currentCountries[indexPath.row]
        let state = _currentState()

        if let cell = tableView.dequeueReusableCell(withIdentifier: CountryCellView.cellReuseId, for: indexPath) as? CountryCellView {
            cell.configure(countryInfo: countryInfo)
            cell.updateAppearance(state)
            return cell
        } else {
            return UITableViewCell()
        }
    }
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - UISearchBarDelegate
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("searchBar - seatchText = \(searchText)")
		self._setSearchText(searchText)
	}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        _searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _searchText = ""
        //TODO: ??
        _searchBar.resignFirstResponder()
    }
	
	// MARK: - Events
	
	@objc
	private func onButtonSearchDidTap() {
		self.setIsSearching(!_isSearching, animated: true)
	}
	
	@objc
	private func onButtonFlagDidTap() {
        _isFlaggOn = !_isFlaggOn
        _buttonFlag.image = _isFlaggOn ? UIImage(systemName: "flag.fill") : UIImage(systemName: "flag")

        //Table update - on state change
        updateCellsState()
    }

    @objc
    private func onButtonCodeDidTap() {
        _isCodeOn = !_isCodeOn
        _buttonCode.image = _isCodeOn ? UIImage(systemName: "number.square.fill") : UIImage(systemName: "number.square")

        //Table update - on state change
        updateCellsState()
    }

    private func updateCellsState() {
        let nextCellState = _currentState()

        _tableView.beginUpdates()
        _tableView.visibleCells.forEach { cell in
            if let countryCell = cell as? CountryCellView {
                countryCell.updateAppearance(nextCellState, animated: true)
            }
        }
        //Workaround - max(visible) + 1 was not being refreshed
        if let maxRow = _tableView.indexPathsForVisibleRows?.last {
           let nextRow = IndexPath(row: maxRow.row + 1, section: maxRow.section)
            if let cell = _tableView.cellForRow(at: nextRow) as? CountryCellView {
                cell.updateAppearance(nextCellState, animated: true)
            }

        }
        _tableView.endUpdates()
    }

	// MARK: -

}


