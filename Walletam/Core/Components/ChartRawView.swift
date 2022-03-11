//
//  ChartView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/14/22.
//

import SwiftUI

struct ChartRawView: View {
    
     let data: [Double]
     let maxY: Double
     let minY: Double
     let lineColor: Color
     let startingDate: Date
     let endingDate: Date
    @State var percentage: CGFloat = 0
    
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(chartBackground.opacity(0.5))
                .overlay(chartYAxis
                            .font(Font.custom("BYekan+", size: 14))
                            .foregroundColor(Color.theme.SecondaryText)
                            .padding(.horizontal, 5), alignment: .leading
                )
            chartXAxis
                .padding(.horizontal, 5).foregroundColor(Color.theme.SecondaryText).font(Font.custom("BYekan+", size: 14))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
        
    }
}

//MARK: EXTENSIONS
extension ChartRawView {
    
    //MARK: VIEWS
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x:xPosition, y:yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 5, x: 0, y: 5)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartXAxis: some View {
        HStack {
            Text("\(startingDate.asShortDateString())")
            Spacer()
            Text("\(endingDate.asShortDateString())")
        }
    }
}

//MARK: PREVIEW
struct ChartRawView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
            .preferredColorScheme(.dark)
    }
}

