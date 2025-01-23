//
//  MeView.swift
//  HotProspects
//
//  Created by Saydulayev on 22.01.25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Details")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        TextField("Name", text: $name)
                            .textContentType(.name)
                            .font(.system(size: 18))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        
                        TextField("Email address", text: $emailAddress)
                            .textContentType(.emailAddress)
                            .font(.system(size: 18))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Text("Your QR Code")
                            .font(.headline)
                        
                        Image(uiImage: qrCode)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .contextMenu {
                                ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                            }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            //.scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Your code")
            .onAppear(perform: updateCode)
            .onChange(of: name, updateCode)
            .onChange(of: emailAddress, updateCode)
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
