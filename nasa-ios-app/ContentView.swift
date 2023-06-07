//
//  ContentView.swift
//  nasa-ios-app
//
//  Created by Aluno ISTEC on 24/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    
    
    
    @StateObject var load = loadData(url: "https://api.nasa.gov/planetary/earth/")
    @State var imageUrl = ""
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Hello, miguel!")
                Spacer()
                
                HStack {
                    Spacer().frame(width: 180)
                    NavigationLink(destination: MapView()) {
                                        Image("mapIcon")
                                            .resizable()
                                            .frame(width: 50, height: 40)
                                    }
                    DatePicker("", selection: $load.date, in: ...Date(), displayedComponents: .date)
                    Spacer().frame(width: 100)
                }
                
                AsyncImage(url: URL(string: imageUrl)){ image in
                    
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                    
                }placeholder: {
                    ProgressView()
                }.frame(width: 350, height: 350)
                Spacer()
                
                Button{
                    
                }label: {
                    Text ("RANDOM")
                }
                Spacer().frame(width: 350, height: 50)
                
            }.onAppear{
                Task{
                    do {
                        
                        if let res = try await load.loadAsync() {imageUrl = res.url}
                        
                    } catch {
                        print("Erro")
                    }
                    
                }//Task
            }//onAppear
            .onChange(of: load.date) { newValue in
                Task{
                    do {
                        imageUrl = ""
                        if let res = try await load.loadAsync() {imageUrl = res.url}
                        
                    } catch {
                        print("Erro")
                    }
                    
                }//Task
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
