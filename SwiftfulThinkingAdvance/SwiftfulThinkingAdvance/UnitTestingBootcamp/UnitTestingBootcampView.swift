//
//  UnitTestingBootcampView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/1/24.
//

import SwiftUI

struct UnitTestingBootcampView: View {
    @StateObject var vm: UnitTestingBootcampViewModel
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

struct UnitTestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestingBootcampView(isPremium: false)
    }
}
