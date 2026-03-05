//
//  ChartView.swift
//  car_manager
//
//  Created by Jindra on 14.06.2022.
//

import SwiftUI

struct ChartView: View {
    
    let values: [Double]
    
    var body: some View {
        VStack{
            PieChartView(values: values,
                             names: ["Maintenance", "Taxes", "Toll", "Repairs"],
                             formatter: {value in String(format: "$%.2f", value)},
                             colors: [
                                Color(CustomColor.chartBlue!),
                                Color(CustomColor.chartGreen!),
                                Color(CustomColor.chartOrange!),
                                Color(CustomColor.chartPurple!)],
                             backgroundColor: .white,
                             innerRadiusFraction: 0.6)
                .padding()
        }
        .navigationTitle("Expenses chart")
    }
}
