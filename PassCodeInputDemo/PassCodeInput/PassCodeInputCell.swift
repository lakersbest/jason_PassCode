
import Foundation
import SwiftUI

protocol CharacterFieldBackspaceDelegate {
    func charFieldWillDeleteBackward(_ textField: CharacterField)
}

class CharacterField: UITextField {
    public var willDeleteBackwardDelegate: CharacterFieldBackspaceDelegate?

    override func deleteBackward() {
        willDeleteBackwardDelegate?.charFieldWillDeleteBackward(self)
        super.deleteBackward()
    }

}

struct PassCodeInputCell : UIViewRepresentable {
    
    typealias UIViewType = CharacterField

    var index: Int

    @Binding var selectedCellIndex: Int
    @Binding var textReference: String
    
    func makeUIView(context: UIViewRepresentableContext<PassCodeInputCell>) -> CharacterField {

        let charField = CharacterField(frame: .zero)
        charField.textAlignment = .center

        charField.autocapitalizationType = .none
        charField.autocorrectionType = .no

        charField.delegate = context.coordinator
        charField.willDeleteBackwardDelegate = context.coordinator

        return charField
    }
    
    func updateUIView(_ uiView: CharacterField,
                      context: UIViewRepresentableContext<PassCodeInputCell>) {
        if index == selectedCellIndex {
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(index: index, selectedCellIndex: self.$selectedCellIndex, textReference: self.$textReference)
    }

    class Coordinator : NSObject, UITextFieldDelegate, CharacterFieldBackspaceDelegate{

        var index: Int

        @Binding var selectedCellIndex: Int
        @Binding var textReference: String

        init(index: Int, selectedCellIndex: Binding<Int>,
             textReference: Binding<String>) {
            _selectedCellIndex = selectedCellIndex
            _textReference = textReference
            self.index = index
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                        
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count == 1 {
                self.selectedCellIndex += 1
            }
            
            return updatedText.count <= 1
            
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.textReference = textField.text ?? ""
        }

        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            self.selectedCellIndex = self.index
            return true
        }

        func charFieldWillDeleteBackward(_ textField: CharacterField) {
            if(textField.text == "" && selectedCellIndex > 0) {
                self.selectedCellIndex -= 1
            }
        }

    }
}
