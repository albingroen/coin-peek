//
//  coin_peekApp.swift
//  Coin Peek
//
//  Created by Albin Groen on 2022-05-09.
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

@main
struct coin_peekApp: App {
  init() {
    setUpDependencies()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView().frame(maxWidth: 1200, maxHeight: 600)
    }
    .windowStyle(.hiddenTitleBar)
  }
}

private extension coin_peekApp {
  func setUpDependencies() {
    SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
  }
}
