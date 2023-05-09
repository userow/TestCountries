//
//  CountryInfo.swift
//  TestCountries
//
//  Created by John Doe on 24.04.2023.
//

import Foundation

// TODO: Implement

public class CountryInfo: NSObject {
	
	// MARK: - Declarations. Private
	
	private let _name: String
	private let _flagSymbol: String
	
	// MARK: - Initialize
	
	public required init(name: String, flagSymbol: String) {
		_name = name
		_flagSymbol = flagSymbol
	}
	
	// MARK: - Public
	
	public var name: String {
		return _name
	}
	
	public var flagSymbol: String {
		return _flagSymbol
	}
	
	// MARK: -

}


