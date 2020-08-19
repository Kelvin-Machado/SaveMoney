//
//  TextFormatter.swift
//  SaveMoney
//
//  Created by Kelvin Batista Machado on 21/11/19.
//  Copyright © 2019 Kelvin Batista Machado. All rights reserved.
//

import UIKit



extension String {

//     formats text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
}

extension CardController {
    
//    MARK: - Formats Credit Card Number
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""

        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         
        let newLength = (textField.text ?? "").count + string.count - range.length
        
//        Formats Credit Card Number Length
        if(textField == numCartaoTxt || textField == numCartaoDebitoTxt) {
             return newLength <= 19
         }
        
//        Formats Expiry Date
        if textField == vencimento {
            
            if vencimento.text?.count == 2 {
                
//                salvar valor raw do vencimento
                
//                if (Cartao.vencimentoRaw != nil) {
//                    Cartao.vencimentoRaw.append(string)
//                }else{
//                    Cartao.vencimentoRaw = string
//                }
                
//              Formata data de vencimento
                if !(string == "") {
                    vencimento.text = vencimento.text! + "/"
                }
                
            }
            return !(textField.text!.count >= 5 && (string.count ) > range.length)
        }
        else {
            
            return true
        }
    }
}

extension EmitenteController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == telefoneTxt) {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)

            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.hasPrefix("1")

            if length == 0 || (length > 11 && !hasLeadingOne) || length > 12 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                return (newLength > 11) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()

            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 2 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 2))
                formattedString.appendFormat("(%@)", areaCode)
                index += 2
            }
            if length - index > 5 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 5))
                formattedString.appendFormat("%@-", prefix)
                index += 5
            }

            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        
        if textField == cpfTxt {
            if cpfTxt.text?.count == 3 {

                if !(string == "") {
                    cpfTxt.text = cpfTxt.text! + "."
                }
            }
            if cpfTxt.text?.count == 7 {

                if !(string == "") {
                    cpfTxt.text = cpfTxt.text! + "."
                }
            }
            if cpfTxt.text?.count == 11 {

                if !(string == "") {
                    cpfTxt.text = cpfTxt.text! + "-"
                }
            }
            return !(textField.text!.count >= 14 && (string.count ) > range.length)
        }
        
        if textField == cnpjTxt {
            if cnpjTxt.text?.count == 2 {

                if !(string == "") {
                    cnpjTxt.text = cnpjTxt.text! + "."
                }
            }
            if cnpjTxt.text?.count == 6 {

                if !(string == "") {
                    cnpjTxt.text = cnpjTxt.text! + "."
                }
            }
            if cnpjTxt.text?.count == 10 {

                if !(string == "") {
                    cnpjTxt.text = cnpjTxt.text! + "/"
                }
            }
            if cnpjTxt.text?.count == 15 {

                if !(string == "") {
                    cnpjTxt.text = cnpjTxt.text! + "-"
                }
            }
            return !(textField.text!.count >= 18 && (string.count ) > range.length)
        }else {
            return true
        }
    }
}
extension StringProtocol {
    var isValidCPF: Bool {
        let numbers = compactMap({ $0.wholeNumberValue })
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = slice.count + 2
            let digit = 11 - slice.reduce(into: 0) {
                number -= 1
                $0 += $1 * number
            } % 11
            return digit >= 10 ? 0 : digit
        }
        let dv1 = digitCalculator(numbers.prefix(9))
        let dv2 = digitCalculator(numbers.prefix(10))
        return dv1 == numbers[9] && dv2 == numbers[10]
    }

    var isValidCNPJ: Bool {
        let numbers = compactMap({ $0.wholeNumberValue })
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = 1
            let digit = 11 - slice.reversed().reduce(into: 0) {
                number += 1
                $0 += $1 * number
                if number == 9 { number = 1 }
            } % 11
            return digit % 10
        }
        let dv1 = digitCalculator(numbers.prefix(12))
        let dv2 = digitCalculator(numbers.prefix(13))
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
}

extension String {
func toDecimalWithAutoLocale() -> Decimal? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "pt_BR")

    if let number = formatter.number(from: self) {
       return number.decimalValue
    }
    return nil
    
    }
    func toDoubleWithAutoLocale() -> Double? {
        guard let decimal = self.toDecimalWithAutoLocale() else {
            return nil
        }
        return NSDecimalNumber(decimal: decimal).doubleValue
    }
}
extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
