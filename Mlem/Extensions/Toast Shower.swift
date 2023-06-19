//
//  Toast Shower.swift
//  Mlem
//
//  Created by tht7 on 19/06/2023.
//

import Foundation
import AlertToast
import SwiftUI

private struct ToastShower: EnvironmentKey {
    static let defaultValue = { (message: AlertToast) -> Void in  }
}

extension EnvironmentValues {
    var displayToast: (AlertToast) -> Void {
        get { self[ToastShower.self] }
        set { self[ToastShower.self] = newValue }
      }
}
