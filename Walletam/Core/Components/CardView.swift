//
//  CardView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/16/22.
//

import SwiftUI

struct CardView: View {
    
    var code: Double
    var name: String?
    var CVV2: String?
    var amount: String?
    var expDate: String?

    
    var body: some View {
        HStack {
            VStack {
                //Card Name
                HStack{
                    Spacer()
                    Text(name ?? "")
                        .font(Font.custom("BYekan+", size: 26))
                }.padding()
                
                HStack {
                    Text(amount ?? "")
                }
                
                Spacer()
                
                //Card Number
                Text(code.asCreaditCardString())
                    .font(Font.custom("BYekan+", size: 24))
                    .lineLimit(1)
                Spacer()
                
                HStack {
                    //CVV2
                    Text(CVV2 ?? "")
                    Spacer()
                    //Expire Date
                    Text(expDate ?? "")
                }.padding(.bottom).padding(.leading).padding(.trailing)
            }
            .frame(maxWidth: 350, maxHeight: 200)
            .frame(width: UIScreen.main.bounds.width * 0.88 , height: UIScreen.main.bounds.height * 0.26)
            
        }.padding().background(RoundedRectangle.init(cornerRadius: 15).padding().shadow(radius: 10)
                                .foregroundColor(cardColorSelector())
                                .frame(maxWidth: 400, maxHeight: 253.16)
        )
    }
    
    func cardColorSelector() -> Color {
        print(code.asNumberString())
        //enbank & iranzamin
        if code.asEngNumberString().hasPrefix("627412") || code.asEngNumberString().hasPrefix("505785") {
            return Color.card.purple
        }
        //1-Ansar 2-Hekmat 3-Ghavamin 4-Kosar 5-Mehr 6-Sepah], Maskan
        else if code.asEngNumberString().hasPrefix("627381") || code.asEngNumberString().hasPrefix("636949") || code.asEngNumberString().hasPrefix("639599") || code.asEngNumberString().hasPrefix("505801") || code.asEngNumberString().hasPrefix("639370") || code.asEngNumberString().hasPrefix("589210") || code.asEngNumberString().hasPrefix("628023") {
            return Color.card.orange
        }
        //1,2-Parsian 3,Ayande
        else if code.asEngNumberString().hasPrefix("622106") || code.asEngNumberString().hasPrefix("627884") || code.asEngNumberString().hasPrefix("626314") {
            return Color.card.grey
        }
        //1,2-BPI
        else if code.asEngNumberString().hasPrefix("502229") || code.asEngNumberString().hasPrefix("639347") {
            return Color.card.yellow
        }
        //1-Tejarat 2-Refah 3-Sarmaye 4-Sina 5-Saderat 6-SanaatOMadan 7-CentralBank 8-Melli
        else if code.asEngNumberString().hasPrefix("627353") || code.asEngNumberString().hasPrefix("589463") || code.asEngNumberString().hasPrefix("639607") || code.asEngNumberString().hasPrefix("639346") || code.asEngNumberString().hasPrefix("603769") || code.asEngNumberString().hasPrefix("627961") || code.asEngNumberString().hasPrefix("636795") || code.asEngNumberString().hasPrefix("603799") {
            return Color.card.blue
        }
        //1-ToseeTaavon 2, 3-ToseeSaderat 4-Post 5-MehrIran 6,7-Karafarin 8,9-Keshavarzi
        else if code.asEngNumberString().hasPrefix("502908") || code.asEngNumberString().hasPrefix("627648") || code.asEngNumberString().hasPrefix("207177") || code.asEngNumberString().hasPrefix("627760") || code.asEngNumberString().hasPrefix("606373") || code.asEngNumberString().hasPrefix("627488") || code.asEngNumberString().hasPrefix("502910") || code.asEngNumberString().hasPrefix("603770") || code.asEngNumberString().hasPrefix("639217") {
            return Color.card.green
        }
        //1-Dey 2-Saman
        else if code.asEngNumberString().hasPrefix("502938") || code.asEngNumberString().hasPrefix("621986") {
            return Color.card.aqua
        }
        //1-Shahr 2-Tourism 3,4-Mellat 5-Tosee
        else if code.asEngNumberString().hasPrefix("502806") || code.asEngNumberString().hasPrefix("505416") || code.asEngNumberString().hasPrefix("610433") || code.asEngNumberString().hasPrefix("991975") || code.asEngNumberString().hasPrefix("628157") {
            return Color.card.red
        }
        //
        else {
            return Color.theme.SecondaryText
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        //Dummy Info
        CardView(code: 5022297894561234, name: "حساب بلند مدت بانک ملت", CVV2: "456", amount: "120000000", expDate: "12/09")
    }
}
