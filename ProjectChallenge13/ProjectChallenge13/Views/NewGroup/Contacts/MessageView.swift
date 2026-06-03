//
//  MessageView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//  Built with AI assistance

import MessageUI
import SwiftUI

/// A SwiftUI wrapper for `MFMessageComposeViewController` that allows the user to send a SMS message.
struct MessageView: UIViewControllerRepresentable {
    /// The phone numbers to send the message to.
    var recipients: [String]
    /// The pre-filled message body.
    var body: String
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    /// Coordinator that handles the message compose delegate callbacks.
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        
        /// Dismisses the composer when the user finishes or cancels.
        /// - Parameter result: The result of the message composition.
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
}
