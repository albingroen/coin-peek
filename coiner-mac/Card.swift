//
//  Card.swift
//  coiner-mac
//
//  Created by Albin Groen on 2022-05-10.
//

import SwiftUI

struct Card<Content: View>: View {
  @Environment(\.colorScheme) var colorScheme
  
  var heading: String?
  
  @ViewBuilder var content: Content
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      if let headingText = heading {
        Text(headingText).font(.system(size: 16)).opacity(0.75)
      }
      
      VStack(alignment: .leading, spacing: 0) {
        content
      }.frame(alignment: .topLeading)
    }
    .padding(16)
    .background(colorScheme == .dark ? .gray.opacity(0.2) :  .white)
    .cornerRadius(6)
    .frame(alignment: .topLeading)
    .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 2)
  }
}
