//
//  ContentView.swift
//  searchSnack
//
//  Created by Kyohei Morinaka on 2022/01/05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var snackDataList = snackData()
    @State var inputText = ""
    @State var showSafari = false
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing)
    var body: some View {
        ZStack {
            backGroundColor
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
            VStack{
                TextField("KeyWords", text: $inputText, prompt: Text("Put KeyWords"))
                    .onSubmit {
                        Task {
                            await snackDataList.searchSnack(keyword: inputText)
                        }
                    }
                    .submitLabel(.search)
                    .padding()
                List(snackDataList.snackList) { snack in
                    Button(action: {
                        showSafari.toggle()
                    }) {
                        HStack {
                            AsyncImage(url: snack.image) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 40)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(snack.name)
                        }
                    }
                    .sheet(isPresented: self.$showSafari, content: {
                        SafariView(url: snack.link)
                            .edgesIgnoringSafeArea(.bottom)
                    })
                }
            }
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
