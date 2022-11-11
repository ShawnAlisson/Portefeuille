//
//  CoinRowView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/5/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let showHoldingColumn: Bool
    let showCurrencyChange: Bool
    
    @EnvironmentObject private var vm: HomeViewModel
    
    let coin: CoinModel
    
    var body: some View {
        VStack {
            HStack {
                if showHoldingColumn {
                    leftColumnPortfolio
                    Spacer()
                    rightColumnPortfolio
                } else if !showHoldingColumn {
                    leftColumn
                    Spacer()
                    rightColumn
                }
            }
            .font(.subheadline)
            .background(Color.theme.background.opacity(0.001))
        }
    }
}

//MARK: EXTENSIONS
extension CoinRowView {
    
    //MARK: VIEWS
    private var leftColumn: some View {
        HStack(spacing: 5) {
            Text(vm.translateState ? "\(coin.rank)" : "\(coin.rank.engToFaInt())")
                .font(Font.custom("BYekan+", size: 12))
                .foregroundColor(Color.theme.SecondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.leading, 6)
        }
    }
    
    private var leftColumnPortfolio: some View {
        
        HStack(spacing: 5) {
            CoinImageView(coin: coin)
                .frame(width: 45, height: 45)
            VStack(alignment: .leading) {
                Text("\(coin.symbol.uppercased())")
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.leading, 6)
                HStack {
                    if showCurrencyChange {
                        let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
                        
                        Text(vm.translateState ? "\((coin.currentPrice * newTethPrice / 10 ).asTomanWithTwoDecimalsEng())" : "\((coin.currentPrice * newTethPrice / 10 ).asTomanWith2Decimals())")
                            .modifier(PersianTwelveSolo())
                            .foregroundColor(Color.theme.SecondaryText)
                        Text(vm.translateState ? "\(coin.priceChangePercentage24H?.asPercentStringENG() ?? "")" : "\(coin.priceChangePercentage24H?.asPercentString() ?? "")")
                            .modifier(PersianTwelveSolo())
                            .foregroundColor(
                                (coin.priceChangePercentage24H ?? 0) >= 0 ?
                                Color.theme.green : Color.theme.red
                            )
                    } else if !showCurrencyChange {
                        Text(vm.translateState ? "\(coin.currentPrice.asCurrencyWith6DecimalsENG())" : "\(coin.currentPrice.asCurrencyWith6Decimals())")
                            .modifier(PersianTwelveSolo())
                            .foregroundColor(Color.theme.SecondaryText)
                        Text(vm.translateState ? "\(coin.priceChangePercentage24H?.asPercentStringENG() ?? "")" : "\(coin.priceChangePercentage24H?.asPercentString() ?? "")")
                            .modifier(PersianTwelveSolo())
                            .foregroundColor(
                                (coin.priceChangePercentage24H ?? 0) >= 0 ?
                                Color.theme.green : Color.theme.red
                            )
                    }
                }
            }
        }
    }
    
    private var rightColumnPortfolio: some View {
        
        VStack(alignment: .trailing) {
            if showCurrencyChange {
                let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
                Text(vm.translateState ? (coin.currentHoldingsValue * newTethPrice / 10).asTomanWithTwoDecimalsEng() : (coin.currentHoldingsValue * newTethPrice / 10).asTomanWith2Decimals())
                //.bold()
                    .font(Font.custom("BYekan+", size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(vm.translateState ? (coin.currentHoldings ?? 0).asCryptoUnlimitedDecimalEng() : (coin.currentHoldings ?? 0).asCryptoUnlimitedDecimal())
                    .modifier(PersianFourteenSolo())
                    .foregroundColor(Color.theme.SecondaryText)
            } else if !showCurrencyChange {
                Text(vm.translateState ? coin.currentHoldingsValue.asDollarWithTwoDecimalsEng() : coin.currentHoldingsValue.asCurrencyWith6Decimals())
                    .font(Font.custom("BYekan+", size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(vm.translateState ? (coin.currentHoldings ?? 0).asCryptoUnlimitedDecimalEng() : (coin.currentHoldings ?? 0).asCryptoUnlimitedDecimal())
                    .modifier(PersianFourteenSolo())
                    .foregroundColor(Color.theme.SecondaryText)
            }
        }
        .multilineTextAlignment(.trailing)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            
            if showCurrencyChange {
                let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
                Text(vm.translateState ? "\((coin.currentPrice * newTethPrice / 10).asTomanWithTwoDecimalsEng())" : "\((coin.currentPrice * newTethPrice / 10).asTomanWith6Decimals())")
                    .font(Font.custom("BYekan+", size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(vm.translateState ? "\(coin.priceChangePercentage24H?.asPercentString() ?? "")" : "\(coin.priceChangePercentage24H?.asPercentStringENG() ?? "")")
                    .font(Font.custom("BYekan+", size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.theme.green : Color.theme.red
                    )
            } else if !showCurrencyChange {
                Text(vm.translateState ? "\(coin.currentPrice.asDollarWithTwoDecimalsEng())" : "\(coin.currentPrice.asCurrencyWith6Decimals())")
                    .font(Font.custom("BYekan+", size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(vm.translateState ? "\(coin.priceChangePercentage24H?.asPercentStringENG() ?? "")" : "\(coin.priceChangePercentage24H?.asPercentString() ?? "")")
                    .font(Font.custom("BYekan+", size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.theme.green : Color.theme.red
                    )
            }
            
        }
    }
}

//MARK: PREVIEW
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(showHoldingColumn: false, showCurrencyChange: false, coin: dev.coin).previewLayout(.sizeThatFits)
            CoinRowView(showHoldingColumn: true, showCurrencyChange: false, coin: dev.coin ).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
        }
    }
}
