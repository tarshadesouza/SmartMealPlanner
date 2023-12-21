//
//  DotProgressView.swift
//  FitMealPlanner
//
//  Created by Tarsha de Souza on 20/12/2023.
//

import Foundation
import SwiftUI

struct DotProgressView: View {
	@State private var y: CGFloat = 0
	
	var body: some View {
		HStack{
			Dot(y: y)
				.animation(.easeInOut(duration: 0.5).repeatForever().delay(0), value: y)
			Dot(y: y)
				.animation(.easeInOut(duration: 0.5).repeatForever().delay(0.2), value: y)
			Dot(y: y)
				.animation(.easeInOut(duration: 0.5).repeatForever().delay(0.4), value: y)
		}
		.onAppear{y = -10}
	}
}

struct Dot: View {
	var y: CGFloat
	
	var body: some View {
		Circle()
			.frame(width: 8, height: 8, alignment: .center)
			.opacity(y == 0 ? 0.1 : 1)
			.offset(y: y)
			.foregroundColor(.pastelMint)
	}
}
