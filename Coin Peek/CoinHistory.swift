//
//  CoinHistory.swift
//  Coin Peek
//
//  Created by Albin Groen on 2022-05-13.
//

import SwiftUI
import Alamofire

struct CoinHistory: View {
  @Environment(\.colorScheme) var colorScheme

  var history: [HistoryEntry]
  
  @State private var hovering: HistoryEntry?
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      ScrollView(.horizontal) {
        LazyHStack(alignment: .bottom, spacing: 2.5) {
          ForEach(history.reversed(), id: \.timestamp) { entry in
            VStack {
              RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(LinearGradient(colors: [.blue,  .blue.opacity(hovering?.timestamp == entry.timestamp ? 1 : 0)], startPoint: .top, endPoint: .bottom))
                .frame(width: 3, height: (Double(entry.normalizedPrice) ?? 0) * 200)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .onHover { over in
              withAnimation(.easeOut(duration: 0.2)) {
                self.hovering = entry
              }
            }
          }
        }.frame(height: 200, alignment: .topLeading)
      }.onHover { over in
        if (!over) {
          withAnimation(.easeOut(duration: 0.2)) {
            self.hovering = nil
          }
        }
      }
      
      
      if let historyEntry = hovering {
        VStack(alignment: .leading, spacing: 6) {
          Text("$\(Double(historyEntry.price) ?? 0)").font(.system(size: 16))
          Text(Date(timeIntervalSince1970: Double(historyEntry.timestamp)), style: .date).opacity(0.75)
        }
        .padding()
        .background(colorScheme == .dark ? .indigo : .blue)
        .foregroundColor(.white)
        .cornerRadius(6).zIndex(1)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
      }
      
    }
  }
}

struct CoinHistory_Previews: PreviewProvider {
  static var previews: some View {
    CoinHistory(history: [])
  }
}
