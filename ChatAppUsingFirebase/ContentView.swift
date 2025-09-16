//
//  ContentView.swift
//  ChatAppUsingFirebase
//
//  Created by Neosoft on 11/09/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct ContentView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var erorrMessageEmail: String = ""
    @State private var firebaseError:String? = nil
    @State private var isLoggedInMode: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showPicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var showToast: Bool = false
    @State private var toastMassage: String = ""
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                
                    Picker(selection: $isLoggedInMode) {
                        Text("Log in")
                            .tag(true)
                     
                        Text("Create Account")
                            .tag(false)
                          
                    } label: {
                        
                    }
                    .pickerStyle(.segmented)
                    
                    
                    Label("Whats Your Email and Password", systemImage: "")
                        .bold()
                        .foregroundColor(.primary)
                        .font(.system(size: 25))
                        .onAppear {
                            print("label is appeared")
                        }
                        
                    Button {
                        showPicker = true
                    } label: {
                        if let image = selectedImage{
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.black, lineWidth: 3)
                                        
                                }
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(20)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.black, lineWidth: 3)
                                        
                                }
                                .shadow(radius: 5)
                        }
                        
                    }

                    CustomTextField(
                        title: "Email",
                        placerHolder: "Enter Email",
                        value: $email,
                        errorMessage: erorrMessageEmail
            
                    )
        //            Label(erorrMessageEmail, systemImage: "")
        //                .foregroundStyle(Color.red)
            
                     
                    CustomTextField(
                        title: "Password",
                        placerHolder: "Enter Password",
                        value: $password,
                       
                    )
                    
                    if let errorMessage = firebaseError, !errorMessage.isEmpty{
                        Label(errorMessage, image: "")
                    }
                    
                    Button("Submit") {
                        if email.isEmpty {
                            print("Called")
                            erorrMessageEmail = "Email is required"
                            print(erorrMessageEmail)
                        }else{
                            if isLoggedInMode{
                                logginUser(email: email, password: password)
                                    showToast = true
                                    toastMassage = "Logged in Succesfully!"
                            }else{
                                // api call
                                signInUser(em: email, pas: password)
                                    showToast = true
                                    toastMassage = "Sign up Successfully!"
                            }
                        }
                    }
                    .toast(message: $toastMassage, show: $showToast)
                    .foregroundStyle(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color.red)
                    .font(.system(size: 20))
                    .padding()
                    
                    Spacer()
                }
                .fullScreenCover(isPresented: $showPicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
//                .onChange(of: selectedImage ?? UIImage()) { newValue in
//                    persistantImageStoarage(userImages: newValue)
//                }
                
                
                
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .navigationTitle(isLoggedInMode ? "Login" : "Sign Up")
            .navigationDestination(isPresented: $isLoggedIn, destination: {
                ChatViewListView()
            })
            
            
        }
        
        
        
    }
        
    
    func signInUser(em: String, pas:String){
        Auth.auth().createUser(withEmail: em, password: pas) { result, error in
            if let error = error {
                print("\(error)")
                firebaseError = "\(error)"
            }else {
                firebaseError = "\(result?.user.uid)"
            }
        }
    }
    
    func logginUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("\(error)")
                firebaseError   = "\(error)"
                
            }else{
                print("\(String(describing: result?.user))")
                
                firebaseError = (String(describing: result?.user))
                isLoggedIn = true
                
                
            }
            
        }
        
    }
    
    func persistantImageStoarage(userImages: UIImage){
        
        let fileName = UUID().uuidString
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        let storageRef = Storage.storage().reference().child("\(uId)/\(fileName).jpg")
        
        
        
        guard let imageData = userImages.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        
        storageRef.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                self.firebaseError = "Failed to Push Image to the Storage\(error)"
                print(error)
                
                
            } else {
                self.firebaseError = "Image is Saved Successfully"
                print("Uploaded \(metaData?.path)")
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    self.firebaseError = "Failed to retrive Download URl\(error)"
                    print("Failed to retrive Download URl\(error)")
                } else {
                    self.firebaseError = "Successfully stored image with url \(url?.absoluteString)"
                    
                    print(url?.absoluteString)
                    guard let url = url else {
                        print("Can not get Url")
                        return
                    }
                    storeImageTo(imageUrl: url)
                    
                }
            }
        }
    }
    
    func storeImageTo(imageUrl: URL){
        
        guard let uId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let userData: [String: Any] = ["Email": self.email, "Password": self.password, "userProfileImage": imageUrl.absoluteString]
        
        Firestore.firestore().collection(uId).document().setData(userData) { error in
            if let error = error {
                self.firebaseError = "Failed to store Image to Firestore \(error)"
                print("Enable to Store: \(error)")
                return
            }else {
                self.firebaseError = "Image is stored Successfully to Firestore"
            }
        }
        
    }
    
}



#Preview {
    ContentView()
}
