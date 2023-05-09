//
//  CountryCellView.swift
//  TestCountries
//
//  Created by John Doe on 24.04.2023.
//

import UIKit

// TODO: Implement

class CountryCellView: UITableViewCell {
	
	// MARK: - Declarations. Private
	
	private var _countryInfo: CountryInfo? = nil
	
	private let _labelName = UILabel()
	private let _labelFlag = UILabel()
	private let _labelCode = UILabel()
	
	// MARK: - Initialize
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		_labelName.baselineAdjustment = .alignCenters
		self.addSubview(_labelName)
		
		self.setNeedsUpdateConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - 

    func configure(countryInfo: CountryInfo) {

    }
}


