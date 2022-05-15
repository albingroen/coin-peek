//
//  coiner_macApp.swift
//  coiner-mac
//
//  Created by Albin Groen on 2022-05-09.
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

@main
struct coiner_macApp: App {
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

private extension coiner_macApp {
  func setUpDependencies() {
    SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
  }
}
