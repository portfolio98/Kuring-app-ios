//
//  SearchedStaffDetailList.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/06.
//

import SwiftUI
import KuringSDK
import KuringCommons
import MessageUI

struct SearchedStaffDetailList: View {
    @Binding var staff: Staff!
    
    @State var isShowingMailView = false
    @State var isShowingError = false
    @State var isShowingActionSheet = false
    
    var body: some View  {
        List {
            Section(header: Text("주요 정보")) {
                VStack(alignment: .leading) {
                    Text(staff.name)
                        .font(.headline)
                        .foregroundColor(ColorSet.Label.primary.color)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text("\(staff.deptName) · \(staff.collegeName)")
                        .font(.system(size: 11))
                        .foregroundColor(ColorSet.Label.primary.color)
                }
                
            }
            Section(header: Text("연락처")) {
                Text("📧\(staff.email)")
                    .font(.system(size: 0))
                    .foregroundColor(UIColor.link.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture(perform: sendEmail)
                Text("📞\(staff.phone)")
                    .font(.system(size: 0))
                    .foregroundColor(UIColor.link.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isShowingActionSheet.toggle()
                    }
            }
            Section(header: Text("기타 정보")) {
                Text("📍\(staff.lab)")
                    .font(.system(size: 0))
                    .foregroundColor(ColorSet.Label.primary.color)
                Text("📖\(staff.major)")
                    .font(.system(size: 0))
                    .foregroundColor(ColorSet.Label.primary.color)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("appIconLabel")
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(staff: $staff)
        }
        .actionSheet(isPresented: $isShowingActionSheet) {
            ActionSheet(
                title: Text("📞 전화걸기"),
                message: nil,
                buttons: [
                    .default(Text("\(staff.phone)")),
                    .cancel(Text("아이KU! 잘못 눌렀어요."))
                ]
            )
        }
        .alert(isPresented: $isShowingError) {
            Alert(
                title: Text("메일 전송 실패"),
                message: Text("이메일 설정을 확인하고 다시 시도해주세요."),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}

extension SearchedStaffDetailList {
    /// `staff.phoneNumber`를 실제 전화가능한 문자열로 가공한 뒤 전화를 겁니다.
    private func makeCall() {
        //        let validPhoneNumber = staff.phoneNumber.replacingOccurrences(of: CharacterSet.decimalDigits.inverted, with: "")
        let validPhoneNumber = staff.phone.replacingOccurrences(of: "-", with: "") // - 가 아닌 char도 삭제
        guard let phoneURL = URL(string: "tel://" + validPhoneNumber) else { return }
        UIApplication.shared.open(phoneURL)
    }
    
    /// 메일을 보낼 수 있는지 여부를 체크하고 `staff.email`를 이메일 주소 값으로 하는 메일창을 띄웁니다. 보낼 수 없는 상태면 에러창을 띄웁니다.
    private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            Logger.error(#function)
            isShowingError.toggle()
            return
        }
        isShowingMailView.toggle()
    }
}
