//
//  CountryInfo.swift
//  TestCountries
//
//  Created by John Doe on 24.04.2023.
//

import Foundation

public class CountryInfo: NSObject {
	
	// MARK: - Declarations. Private
	
	private let _name: String
	private let _flagSymbol: String
    private let _code: String
	
	// MARK: - Initialize
	
	public required init(name: String,
                         flagSymbol: String,
                         code: String) {
		_name = name
        _flagSymbol = flagSymbol
        _code = code
	}
	
	// MARK: - Public
	
	public var name: String {
		return _name
	}

    public var flagSymbol: String {
		return _flagSymbol
	}
    
    public var code: String {
        return _code
    }

}
