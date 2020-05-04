//
//  Permissions.swift
//  Spokestack Studio iOS
//
//  Created by Daniel Tyreus on 4/20/20.
//  Copyright © 2020 Spokestack. All rights reserved.
//

import SwiftUI
import AVFoundation
import Speech

struct Permissions: View {
    
    @State private var micState:AVAuthorizationStatus = .notDetermined
    @State private var asrState:SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    @Binding var permissionsComplete:Bool;
    
    init(permissionsComplete: Binding<Bool>) {
        self._permissionsComplete = permissionsComplete
        self.checkMic()
        self.checkASR()
    }
    
    func requestMic() {
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            if granted {
                self.checkMic()
            }
        })
    }
    
    func checkMic() {
        print("checking mic state")
        micState = AVCaptureDevice.authorizationStatus(for: .audio)
        print("mic state \(micState.rawValue)")
        
        if ((micState == .authorized) && (asrState == .authorized)) {
            permissionsComplete.toggle()
            UserDefaults.standard.set(true, forKey: "permissions")
        }
    }
    
    func requestASR() {
        SFSpeechRecognizer.requestAuthorization({ authStatus in
            self.checkASR()
        })
    }
    
    func checkASR() {
        asrState = SFSpeechRecognizer.authorizationStatus()
        
        if ((micState == .authorized) && (asrState == .authorized)) {
            permissionsComplete.toggle()
            UserDefaults.standard.set(true, forKey: "permissions")
        }
    }
    
    var body: some View {
        VStack {
            
            Text("Permissions").font(.title).padding()
            
            VStack {
                
                VStack {
                    Text("Spokestack Studio needs your permission to use the voice features of your device. Please tap each permission below to approve and continue.").font(.body).multilineTextAlignment(.center).padding()
                    
                }.background(/*@START_MENU_TOKEN@*/Color("SpokestackForeground")/*@END_MENU_TOKEN@*/).cornerRadius(10).padding()
                
                VStack(alignment: .leading) {
                    Button(action: {
                        self.requestMic()
                        
                    }) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Microphone Access")
                                    .font(.headline)
                                    .foregroundColor(Color.black)
                                Text("Listens for your voice")
                                    .font(.subheadline)
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                            if (micState == .authorized) {
                                Image(systemName: "checkmark.circle.fill").font(.title).foregroundColor(Color("SpokestackBlue"))
                            } else {
                                Image(systemName: "minus.circle").font(.title)
                            }
                        }
                    }
                    Divider()
                }.padding(.horizontal, 8)
                
                VStack(alignment: .leading) {
                    Button(action: {
                        self.requestASR()
                    }) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text("Speech Recognition Access")
                                    .font(.headline)
                                    .foregroundColor(Color.black)
                                Text("Understands your voice")
                                    .font(.subheadline)
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                            if (asrState == .authorized) {
                                Image(systemName: "checkmark.circle.fill").font(.title).foregroundColor(Color("SpokestackBlue"))
                            } else {
                                Image(systemName: "minus.circle").font(.title)
                            }
                        }
                    }
                    Divider()
                }.padding(.horizontal, 8)
                Spacer()
            }
            .background(/*@START_MENU_TOKEN@*/Color("SpokestackBackground")/*@END_MENU_TOKEN@*/)
            
        }
    }
}

struct Permissions_Previews: PreviewProvider {
    //@State private var permissionsComplete:Bool = false
    static var previews: some View {
        Permissions(permissionsComplete:.constant(false))
    }
}
