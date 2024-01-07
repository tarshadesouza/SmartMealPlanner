//
//  CustomFontModifier.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 28/12/2023.
//

import Foundation
import SwiftUI

extension View {
	func regularFont(_ fontSize: CGFloat = 20) -> some View {
		self.font(.custom("NunitoSans-Regular", size: fontSize))
	}

	func lightFont(_ fontSize: CGFloat = 20) -> some View {
		self.font(.custom("NunitoSans-Light", size: fontSize))
	}

	func boldFont(_ fontSize: CGFloat = 20) -> some View {
		self.font(.custom("NunitoSans-Bold", size: fontSize))
	}
}
