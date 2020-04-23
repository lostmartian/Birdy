//
//  ContentView.swift
//  BirdyApp
//
//  Created by Sahil Jitesh Gangurde on 21/04/20.
//  Copyright © 2020 Sahil Jitesh Gangurde. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ContentView: View {
    
    @State var show = false
    
    var body: some View {
        
        ZStack {
            
            TabView{
                
                Home().tabItem ({
                    
                    Image("Home")
                    
                }).tag(0)
                
                Search().tabItem ({
                    
                    Image("Search")
                    
                }).tag(1)
                
                Text("Notifications").tabItem ({
                    
                    Image("Notification")
                    
                }).tag(2)
                
                Text("Messages").tabItem ({
                    
                    Image("Messages")
                    
                }).tag(3)
                
            }.accentColor(.blue)
                .edgesIgnoringSafeArea(.top)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        
                        self.show.toggle()
                        
                    })
                    {
                        Image("Tweet").resizable().frame(width: 20, height: 20).padding()
                    }.background(Color("bg"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                     
                }.padding()
                
            }.padding(.bottom, 65)
            
        }.sheet(isPresented: $show) {
            
            CreateTweet(show: self.$show)
            
        }
    }
}

struct Home : View{
    
    @ObservedObject var observedData = getData()
    
    var body : some View{
        NavigationView{
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack(alignment: .leading) {
                        
                        ForEach(observedData.datas){i in
                            
                            tweetCellTop(name: i.name, id: i.tagid, pic: i.pic, image: i.url, msg: i.msg)
                            
                            if i.pic != ""{
                                tweetCellMiddle(pic: i.pic).padding(.leading, 50)
                            }
                              
                            tweetCellBottom().offset(x: UIScreen.main.bounds.width / 4)
                            
                        }
                         
                    }
                    
                }.padding(.bottom, 15)
                
                
                
            .navigationBarTitle("Home",displayMode: .inline)
            .navigationBarItems(leading:
                
                Image("Bird").resizable().frame(width: 35, height: 35).clipShape(Circle()).onTapGesture {
                    print("Slide out menu...")
                    }
                
            )
        }
    }
}

struct tweetCellBottom : View {
    
    var body : some View{
        
        HStack(spacing: 40){
            
            Button(action: {})
            {
                Image("Comment").resizable().frame(width: 20, height: 20)
            }.foregroundColor(.gray)
            
            Button(action: {})
            {
                Image("Retweet").resizable().frame(width: 20, height: 20)
            }.foregroundColor(.gray)
            
            Button(action: {})
            {
                Image("Love2").resizable().frame(width: 20, height: 20)
            }.foregroundColor(.gray)
            
            Button(action: {})
            {
                Image("Upload").resizable().frame(width: 20, height: 20)
            }.foregroundColor(.gray)
            
        }
        
    }
    
}

struct tweetCellTop: View {
    
    var name = ""
    var id = ""
    var pic = ""
    var image = ""
    var msg = ""
    
    var body : some View{
        
        HStack(alignment: .top){
            
            VStack {
                 
                 AnimatedImage(url: URL(string: image)!).resizable().frame(width: 35, height: 35).clipShape(Circle())
                
            }
            
            
            VStack(alignment: .leading){
                
                Text(name).fontWeight(.heavy)
                Text(id)
                Text(msg).padding(.top, 8)
                
            }
        }.padding()
    }
}

struct tweetCellMiddle : View {
    
    var pic = ""
    
    var body : some View{
        
        AnimatedImage(url: URL(string: pic)!).resizable().frame(height: 300).cornerRadius(10).padding()
        
    }
    
}

struct CreateTweet : View {
    
    @Binding var show : Bool
    @State var txt = ""
    
    var body : some View{
        
        VStack {
            
            HStack {
                  
                Button(action: {
                    
                    self.show.toggle()
                    
                })
                {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button(action: {
                    
                    postTweet(msg: self.txt)
                    self.show.toggle()
                    
                })
                {
                    Text("Tweet").padding()
                }.background(Color("bg"))
                .foregroundColor(.white)
                .clipShape(Capsule())
                
            }
            
            multilineTextField(txt: $txt)
            
        }.padding()
        
    }
    
}

struct multilineTextField : UIViewRepresentable {
    
    @Binding var txt : String
    
    func makeCoordinator() -> multilineTextField.Coordinator  {
        return multilineTextField.Coordinator(parent1 : self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<multilineTextField>) -> UITextView {
        
        let text = UITextView()
        text.isEditable = true
        text.isUserInteractionEnabled = true
        text.text = "Whats on your mind ?"
        text.textColor = .gray
        text.font = .systemFont(ofSize: 20)
        text.delegate = context.coordinator
        return text
        
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<multilineTextField>) {
        
    }
    
    class Coordinator : NSObject, UITextViewDelegate{
        
        var parent : multilineTextField
        
        init(parent1 : multilineTextField) {
            
            parent = parent1
            
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            textView.text = ""
            textView.textColor = .black
            
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            self.parent.txt = textView.text
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct datatype :  Identifiable {
    var id : String
    var name : String
    var msg : String
    var likes : String
    var pic : String
    var url : String
    var tagid : String
}

func postTweet(msg : String) {
    
    let db = Firestore.firestore()
    
    db.collection("tweets").document().setData(["name" : "sahil", "id" : "@lostmartian", "msg": msg, "retweet": "0", "likes": "0", "pic": "", "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/U.S._Navy_151103-N-XX082-001_Morse_Code_training_2015.jpg/440px-U.S._Navy_151103-N-XX082-001_Morse_Code_training_2015.jpg"]) { (err) in
        
        if err != nil {
            
            print((err?.localizedDescription)!)
            
            return
            
        }
        print("Success")
    }
    
}

class getData : ObservableObject{
    @Published var datas = [datatype]()
    init() {
        let db = Firestore.firestore()
        
        db.collection("tweets").addSnapshotListener { (snap, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let msg = i.document.get("msg") as! String
                    let pic = i.document.get("pic") as! String
                    let url = i.document.get("url") as! String
                    let likes = i.document.get("likes") as! String
                    let tagid = i.document.get("id") as! String
                    
                    DispatchQueue.main.async {
                        self.datas.append(datatype(id: id, name: name, msg: msg, likes: likes, pic: pic, url: url, tagid: tagid))
                    }
                }
            }
        }
    }
}

struct Search : View {
    
    var body : some View {
        
        NavigationView {
            
            List(0..<10){i in
                
                Text("Trending \(i)")
                
            }.navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading:
                    
                    HStack{
                        
                        Image("Bird").resizable().frame(width: 35, height: 35).clipShape(Circle()).onTapGesture {
                            
                        print("Slide out menu...")
                            
                        }
                        
                        SearchBar().frame(width: UIScreen.main.bounds.width - 120)
                        
                    }
                    
                    , trailing:
            
                    Button(action: {
                        
                    }, label: {
                        
                        Image("Add").resizable().frame(width: 25, height : 25)
                        
                    }).foregroundColor(Color("bg"))
            
            )
            
        }
        
    }
    
}

struct SearchBar : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        
        let search = UISearchBar()
        return search
        
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        
    }
    
}


