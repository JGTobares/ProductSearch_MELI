//
//  CustomTextField.swift
//  MELI_ProductSearch
//
//  Created by Julio Gabriel Tobares on 28/05/2025.
//
import SwiftUI

struct CustomTextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    
    var isFirstResponder: Bool = false
    var onDone: (() -> Void)? = nil

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        textField.keyboardType = .default
        textField.delegate = context.coordinator

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: context.coordinator,
            action: #selector(Coordinator.doneTapped)
        )

        toolbar.items = [UIBarButtonItem.flexibleSpace(), doneButton]
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        if isFirstResponder, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, onDone: onDone)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var onDone: (() -> Void)?

        init(text: Binding<String>, onDone: (() -> Void)?) {
            self.text = text
            self.onDone = onDone
        }

        @objc func doneTapped() {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
            onDone?()
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }
    }
}
