//
//  QuizView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/02/22.
//

import SwiftUI
import Network

struct QuizView: View {
    
    @State var selectedOption: Int? = nil
    var question: String
    var optionsList: [String]
    var correctOption: Int
    var explanation: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(question)
                    .font(.custom("Poppins-Regular", size: 20))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
                
                ForEach(optionsList, id:\.self) {option in
                    AnswerRow(text: option, isCorrectOption: optionsList.firstIndex(of: option) == correctOption, index: optionsList.firstIndex(of: option)!, selectedOption: $selectedOption)
                        .padding(7)
                }
                
                Text(explanation)
                    .padding(.horizontal)
                    .font(.custom("Poppins-Light", size: 15))
                    .multilineTextAlignment(.leading)
                    .opacity(selectedOption != nil ? 1 : 0)
                
                Spacer()
            }
            .guidePadding()
        }
    }
}


struct AnswerRow: View {
    
    var text: String
    var isCorrectOption: Bool
    var index: Int
    @Binding var selectedOption: Int?
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Poppins-Light", size: 15))
                .padding()
            Spacer()
            Image(systemName: isCorrectOption ? "checkmark.circle.fill" : "xmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(isCorrectOption ? .green : .red)
                .font(.system(size: 23))
                .padding(.trailing)
                .opacity(getOpacity())
            
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("White Black"))
                .shadow(color: getShadowColor(), radius: 5)
                .animation(.spring(), value: getShadowColor())
        )
        .onTapGesture {
            if selectedOption == nil {
                withAnimation(.spring()) {
                    selectedOption = index
                }
            }
        }
    }
    
    func getShadowColor() -> Color {
        if selectedOption != nil {
            if isCorrectOption {
                return .green
            }
            if selectedOption! == index {
                return .red
            }
        }
        return .gray
    }
    
    func getOpacity() -> CGFloat {
        if let selectedOption = selectedOption {
            if selectedOption == index || isCorrectOption {
                return 1
            }
        }
        return 0
    }
}


struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                QuizView(question: "This is question 1", optionsList: ["This is option 1.", "This is option 2.", "This is option 3.", "This is option 4."], correctOption: 2, explanation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce viverra varius tortor, ac laoreet nulla facilisis eget. Vivamus rutrum id dui et aliquet. Proin sed.")
            }
            .preferredColorScheme(.dark)
            //            AnswerRow(text: "This is option 1.", isCorrectOption: false)
            //                .preferredColorScheme(.dark)
        }
    }
}
