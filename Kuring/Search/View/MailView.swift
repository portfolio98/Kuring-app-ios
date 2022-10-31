//
//  MailView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/06.
//

import SwiftUI
import MessageUI
import KuringSDK
import KuringCommons

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var staff: Staff!
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([staff.email])
        
        return vc
    }
    
    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        /// 메일 전송이 완료되었을 때 호출 되는 이벤트 입니다.
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            parent.presentationMode.wrappedValue.dismiss()
            Logger.error(error)
        }
    }

}
