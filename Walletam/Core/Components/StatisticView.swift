//
//  StatisticView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        
        
        VStack(alignment: .center, spacing: 4) {
            Text(stat.title)
                .font(Font.custom("BYekan+", size: 16))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                //.font(.caption)
                .foregroundColor(Color.theme.SecondaryText)
            Text(stat.value)
                .font(Font.custom("BYekan+", size: 14))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "chevron.up.square.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                    
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(Font.custom("BYekan+", size: 12))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.caption)
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}



//MARK: PREVIEW
struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat1)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            StatisticView(stat: dev.stat2)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            StatisticView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
                //.preferredColorScheme(.dark)
        }
        
    }
}
