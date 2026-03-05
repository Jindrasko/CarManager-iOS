//
//  LabelTextField.swift
//  car_manager
//
//  Created by Jindra on 25.05.2022.
//

import SwiftUI

struct LabelTextField: View {
    var labelText: String
    @Binding var textFieldText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(labelText)
                .font(.caption)
            TextField("", text: $textFieldText)
                .font(.body)
            
            
        }.padding(8)
            .background(Color(CustomColor.customLightGray ?? .gray))
        .border(.black, width: 2)
        
    }
}

struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LabelTextField(labelText: "Name", textFieldText: .constant("Empty"))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
