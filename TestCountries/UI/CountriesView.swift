//
//  CountriesView.swift
//  TestCountries
//
//  Created by John Doe on 24.04.2023.
//

import UIKit

// TODO: Implement

class CountriesView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	// MARK: - Declarations. Private
	
	private var _isSearching = true//false
	private var _searchText: String? = nil
	
	private let _navigationItem = UINavigationItem()
	private let _navigationBar = UINavigationBar()
	private let _buttonSearch = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
	
	private let _searchBar = UISearchBar()
	
	private let _tableView = UITableView(frame: .zero, style: .plain)
	
	private let _toolBar = UIToolbar()
	private var _buttonFlag = UIBarButtonItem()
	
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
		
		self.addSubview(_tableView)
		self.addSubview(_searchBar)
		self.addSubview(_navigationBar)
		
		_buttonFlag = UIBarButtonItem(image: UIImage(systemName: "flag"), style: .plain, target: self, action: #selector(onButtonFlagDidTap))
		_toolBar.items = [_buttonFlag]
		
		self.addSubview(_toolBar)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Private
	
	private func setIsSearching(_ isSearching: Bool, animated: Bool) {
		
	}
	
	private func setSearchText(_ searchText: String?) {
		
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
		return CountriesList.shared.countries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let countryInfo = CountriesList.shared.countries[indexPath.row]
		let cellReuseId = "Country cell"
		var cell = _tableView.dequeueReusableCell(withIdentifier: cellReuseId)
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseId)
			cell?.textLabel?.numberOfLines = 0
		}
		cell?.textLabel?.text = countryInfo.name
		return cell!
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - UISearchBarDelegate
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.setSearchText(searchText)
	}
	
	// MARK: - Events
	
	@objc
	private func onButtonSearchDidTap() {
		self.setIsSearching(!_isSearching, animated: true)
	}
	
	@objc
	private func onButtonFlagDidTap() {
		
	}
	
	// MARK: -

}


