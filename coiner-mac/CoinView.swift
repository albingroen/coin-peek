//
//  CoinView.swift
//  coiner-mac
//
//  Created by Albin Groen on 2022-05-10.
//

import SwiftUI
import SDWebImageSwiftUI
import Alamofire

struct CoinAllTimeHigh: Decodable {
  var price: String
  var timestamp: Int
}

struct FullCoin: Decodable {
  var uuid: String
  var symbol: String
  var name: String
  var color: String?
  var iconUrl: String
  var marketCap: String?
  var price: String?
  var listedAt: Int
  var tier: Int
  var change: String?
  var rank: Int
  var sparkline: [String?]?
  var lowVolume: Bool
  var coinrankingUrl: String
  var btcPrice: String?
  var allTimeHigh: CoinAllTimeHigh
}

struct CoinResponse: Decodable {
  var coin: FullCoin
}

class CoinObserver: ObservableObject {
  @Published var coin: FullCoin?
}

struct HistoryEntry: Decodable {
  var normalizedPrice: String
  var timestamp: Int
  var price: String
}

struct HistoryResponse: Decodable {
  var history: [HistoryEntry]
  var change: String
}

class HistoryObserver: ObservableObject {
  @Published var history = [HistoryEntry]()
  @Published var change: String = ""
}

struct CoinView: View {
  var coinId: String
  
  @State private var isHistoryLoading: Bool = false
  @State private var isLoading: Bool = false
  @State private var timePeriod: String = "24h"
  
  @ObservedObject var coin = CoinObserver()
  @ObservedObject var history = HistoryObserver()
  
  func getHistory(period: String) {
    if (history.change == "") {
      self.isHistoryLoading = true
    }
    
    AF.request("https://api.getcoiner.app/api/coins/\(self.coinId)/history?timePeriod=\(period)").responseDecodable(of: HistoryResponse.self) { response in
      if let data = response.value {
        debugPrint(data)
        history.history = data.history
        history.change = data.change
      }
      
      self.isHistoryLoading = false
    }
  }
  
  func getCoin() {
    if (coin.coin == nil) {
      self.isLoading = true
    }
    
    AF.request("https://api.getcoiner.app/api/coins/\(self.coinId)").responseDecodable(of: CoinResponse.self) { response in
      if let data = response.value {
        coin.coin = data.coin
      }
      
      self.isLoading = false
    }
  }
  
  var body: some View {
    VStack {
      if (isLoading) {
        ProgressView().progressViewStyle(.linear).frame(maxWidth: 200)
      } else {
        if let coin = coin.coin {
          VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 20) {
              WebImage(url: URL(string: coin.iconUrl))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)
              
              VStack(alignment: .leading, spacing: 6) {
                Text(coin.name)
                  .font(.system(size: 24, weight: .medium))
                  .frame(width: 500, alignment: .topLeading)
                
                Text(coin.symbol)
                  .font(.system(size: 16))
                  .foregroundColor(.gray)
              }
            }
            
            ScrollView(.horizontal) {
              HStack(spacing: 12) {
                if let price = coin.price {
                  Card(heading: "Current price") {
                    Text("$\((Double(price) ?? 0))").font(.title)
                  }
                }
                
                if let change = coin.change {
                  Card(heading: "Change (24h)") {
                    Text("\(change)%").font(.title)
                      .foregroundColor((Double(change) ?? 0) > 0 ? .green : .red)
                  }
                }
                
                if let allTimeHigh = coin.allTimeHigh {
                  Card {
                    VStack(alignment: .leading, spacing: 10) {
                      HStack {
                        Text("All time high")
                          .font(.system(size: 16)).opacity(0.75)
                        
                        Text("(\(Date(timeIntervalSince1970: Double(allTimeHigh.timestamp) ), style: .date))")
                          .font(.system(size: 16)).opacity(0.75)
                      }
                      
                      Text("$\((Double(allTimeHigh.price) ?? 0))").font(.title)
                    }
                  }
                }
                
                if let marketCap = coin.marketCap {
                  Card(heading: "Market cap") {
                    Text(marketCap).font(.title)
                  }
                }
              }
              .padding(.bottom, 5).padding(.horizontal, 5)
            }
            
            Divider().opacity(0.5)
            
            Card(heading: "Historical prices") {
              if (isHistoryLoading) {
                ProgressView().progressViewStyle(.linear)
              } else {
                VStack(alignment: .leading, spacing: 20) {
                  HStack(alignment: .center, spacing: 10) {
                    Picker("Last", selection: $timePeriod) {
                      Text("24 hours").tag("24h")
                      Text("7 days").tag("7d")
                      Text("30 days").tag("30d")
                      Text("3 months").tag("3m")
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding(.vertical, 4)
                    .onChange(of: timePeriod) { value in
                      print(value)
                      getHistory(period: value)
                    }
                    
                    if let change = history.change {
                      Text("\(change)%")
                        .foregroundColor((Double(change) ?? 0) > 0 ? .green : .red)
                        .fontWeight(.medium)
                    }
                  }.frame(maxWidth: 325)
                  
                  CoinHistory(history: history.history)
                }
                
              }
            }.frame(alignment: .bottomLeading)
          }.frame(maxWidth: .infinity, alignment: .topLeading)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(.horizontal, 20)
    .onAppear {
      getCoin()
      getHistory(period: timePeriod)
    }
  }
}

struct CoinView_Previews: PreviewProvider {
  static var previews: some View {
    CoinView(coinId: "Qwsogvtv82FCd")
      .frame(width: 800.0)
    
  }
}


