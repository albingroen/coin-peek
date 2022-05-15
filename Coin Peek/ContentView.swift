//
//  ContentView.swift
//  Coin Peek
//
//  Created by Albin Groen on 2022-05-09.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI

struct CoinsStats: Decodable {
  var totalMarketCap: String
  var totalCoins: Int
}

struct Coin: Decodable {
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
}

struct CoinsResponse: Decodable {
  var coins: [Coin]
}

class CoinsObserver: ObservableObject {
  @Published var coins = [Coin]()
}

struct ContentView: View {
  @ObservedObject var coins = CoinsObserver()
  
  @State private var search: String = ""
  @State private var isLoading: Bool = false
  
  init() {
    getCoins()
  }
  
  func getCoins(search: String = "") {
    self.isLoading = true
    
    AF.request("https://api.getcoiner.app/api/coins?search=\(search)").responseDecodable(of: CoinsResponse.self) { response in
      if let data = response.value {
        coins.coins = data.coins
      }
      
      self.isLoading = false
    }
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 16) {
        VStack {
          HStack(alignment: .center, spacing: 0) {
            Image(systemName: "magnifyingglass")
              .resizable()
              .scaledToFit()
              .frame(width: 11)
            
            TextField("Search", text: $search)
              .textFieldStyle(.plain)
              .padding(.horizontal, 8).padding(.vertical, 6)
              .onChange(of: search) { newValue in
                print(newValue)
                getCoins(search: newValue)
              }
          }
          .padding(.leading, 10)
          .background(.gray.opacity(0.1))
          .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        
        if (isLoading) {
          ProgressView()
          Spacer()
        } else {
          List {
            ForEach(coins.coins, id: \.uuid) { coin in
              NavigationLink(destination: CoinView(coinId: coin.uuid)) {
                HStack(alignment: .center, spacing: 14) {
                  WebImage(url: URL(string: coin.iconUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text(coin.name).font(.system(size: 16).weight(.medium))
                    if let price = coin.price {
                      Text("$\((Double(price) ?? 0))").font(.system(size: 14)).opacity(0.7)
                    }
                  }.frame(alignment: .topLeading)
                }.padding(6)
              }
            }
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
