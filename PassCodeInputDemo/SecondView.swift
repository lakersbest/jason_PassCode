
import SwiftUI

struct SecondView: View {

    @ObservedObject var passCodeModel: PassCodeInputModel

    var body: some View {
        Form {
            Section {
                PassCodeInputField(inputModel: self.passCodeModel)
            }
            Section {
                Button(LocalizedStringKey("Prompt_Engage"), action: {
                    print(
                        "密碼是 \(self.passCodeModel.passCodeString)"
                    )
                }).disabled(!self.passCodeModel.isValid)
            }
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(passCodeModel: PassCodeInputModel(passCodeLength: 4))
    }
}
