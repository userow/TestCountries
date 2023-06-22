//
//  CountryCellView.swift
//  TestCountries
//
//  Created by John Doe on 24.04.2023.
//

import UIKit

class CountryCellView: UITableViewCell {
	
	// MARK: - Declarations. Private
	// MARK: UI elements
	private let _labelName = UILabel()
	private let _labelFlag = UILabel()
	private let _labelCode = UILabel()

	private let _stackV = UIStackView()
	private let _stackH = UIStackView()

	// MARK: - Initialize

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubviews()
		createConstraints()
	}
	/*
	 1) structure
	 contentView
	 stackH
	 labelFlag
	 stackV
	 labelName
	 labelCode
	 */
	func addSubviews() {
		_labelName.translatesAutoresizingMaskIntoConstraints = false
		_labelName.numberOfLines = 0
		_labelName.textColor = .label
		_labelName.textAlignment = .justified

		_labelCode.translatesAutoresizingMaskIntoConstraints = false
		_labelCode.textColor = .secondaryLabel
		_labelCode.textAlignment = .justified

		_stackV.translatesAutoresizingMaskIntoConstraints = false;
		_stackV.axis = .vertical
		_stackV.distribution  = .fill
		_stackV.alignment = .leading
		_stackV.contentMode = .scaleToFill
		_stackV.setContentHuggingPriority(UILayoutPriority.init(250), for: NSLayoutConstraint.Axis.horizontal)
		_stackV.spacing = 8
		_stackV.addArrangedSubview(_labelName)
		_stackV.addArrangedSubview(_labelCode)

		_labelFlag.translatesAutoresizingMaskIntoConstraints = false;
		_labelFlag.textColor = .label
		_labelFlag.textAlignment = .center

		_stackH.translatesAutoresizingMaskIntoConstraints = false;
		_stackH.axis  = .horizontal
		_stackH.distribution  = .fill
		_stackH.alignment =  .center
		_stackH.contentMode = .scaleToFill
		_stackH.spacing = 8

		_stackH.addArrangedSubview(_labelFlag)
		_stackH.addArrangedSubview(_stackV)

		self.contentView.addSubview(_stackH)
	}

	func createConstraints() {
		NSLayoutConstraint.activate([
			_stackH.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			_stackH.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			_stackH.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			_stackH.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static let cellReuseId = "CountryCellView"

	override func prepareForReuse() {
		configure(countryInfo: nil)
		updateAppearance(CountriesStateDTO())
	}
	
	// MARK: - displayed data manipulation

	/// data displaying / prepare for reuse in case of nil
	func configure(countryInfo: CountryInfo?) {
		NSLog("countryInfo = \(countryInfo?.name ?? ""), \(countryInfo?.code ?? ""), \(countryInfo?.flagSymbol ?? "")")
		_labelName.text = countryInfo?.name ?? ""
		_labelCode.text = countryInfo?.code ?? ""
		_labelFlag.text = countryInfo?.flagSymbol ?? ""
	}

	/// appearance update - flag / code / text highlight
	func updateAppearance(_ state: CountriesStateDTO, animated: Bool = false) {
		// Show - Hide Animation
		let flagSwitched = (_labelFlag.isHidden != !state.isFlagOn)
		let codeSwitched = (_labelCode.isHidden != !state.isCodeOn)

		if flagSwitched || codeSwitched {
			let changes = {
				if flagSwitched {
					self._labelFlag.isHidden = !state.isFlagOn
				}

				if codeSwitched {
					self._labelCode.isHidden = !state.isCodeOn
				}
			}
			if animated {
				let propAnimator = UIViewPropertyAnimator(duration: kAnimationDuration, curve: .easeInOut) {
					changes()
				}
				propAnimator.startAnimation()
			} else {
				changes()
			}
		}

		// Text Highlighting
		highlighText(state.highlightedText, in: _labelName)

		if state.isCodeOn {
			highlighText(state.highlightedText, in: _labelCode)
		}
	}

	private func highlighText(_ text: String, in label: UILabel) {
		if let wholeText = label.text,
		   let attrText = label.attributedText {
			let mutableAttrText = NSMutableAttributedString(attributedString: attrText)
			mutableAttrText.removeAttribute(NSAttributedString.Key.backgroundColor, range: NSMakeRange(0, mutableAttrText.length))
			NSLog("highlighText - DELETED highlight for \(wholeText)")
			if text.count > 0 {
				if let range = wholeText.range(of: text, options: String.CompareOptions.caseInsensitive),
				   let color = UIColor.textHighlightColor {
					let convertedRange = NSRange(range, in: wholeText)
					mutableAttrText.addAttribute(NSAttributedString.Key.backgroundColor,
												 value: color,
												 range: convertedRange)
					label.attributedText = mutableAttrText
				}
			}
		}
	}
}


