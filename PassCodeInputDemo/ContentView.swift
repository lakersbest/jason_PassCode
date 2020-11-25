
import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 12
    var shakesPerUnit = 4
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    
    @ObservedObject var passCodeModel = PassCodeInputModel(passCodeLength: 6)
    @ObservedObject var childPassCodeModel = PassCodeInputModel(passCodeLength: 4)

    @State private var attempts: Int = 0
    @State private var showModal: Bool = false

    private let modalView: ModalRootView = ModalRootView()

    var body: some View {


        NavigationView {
            Form {
                Section {
                    PassCodeInputField(inputModel: self.passCodeModel)
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                }
                Section {
                    Button(LocalizedStringKey("Prompt_ShakeOff"), action: {
                        print("Passcode is \(self.passCodeModel.passCodeString)")

                        withAnimation(.default) {
                            self.attempts += 1
                        }
                        
                    }).disabled(!self.passCodeModel.isValid)
                }
            }
            .sheet(isPresented: $showModal) {
                return self.modalView
            }
            .navigationBarTitle(LocalizedStringKey("First_View"))
            .navigationBarItems(leading:
                Button(action: {
                    self.showModal.toggle()
                }) {
                    Text(LocalizedStringKey("ModalView"))
                },
                                trailing: NavigationLink(destination:
                SecondView(passCodeModel: self.childPassCodeModel)
                .navigationBarTitle(LocalizedStringKey("NestedView")))
            {
              Text(LocalizedStringKey("Child View"))
            }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
