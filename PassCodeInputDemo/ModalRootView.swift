

import SwiftUI

struct ModalRootView: View {

    @ObservedObject var childPassCodeModel = PassCodeInputModel(passCodeLength: 6)

    var body: some View {
        NavigationView {
            List {
                ForEach(0..<6) { index in
                    Text("密碼關卡")
                }
            }
            .navigationBarTitle(LocalizedStringKey("ModalView"))
            .navigationBarItems(trailing: NavigationLink(destination:
                SecondView(passCodeModel: self.childPassCodeModel)
                .navigationBarTitle(LocalizedStringKey("NestedView")))
            {
              Text(LocalizedStringKey("Child View"))
            })
        }
    }
}

struct ModalRootView_Previews: PreviewProvider {
    static var previews: some View {
        ModalRootView()
    }
}
