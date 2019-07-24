//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Created by Kaviraj Pandey on 23/07/2019.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController,SKPaymentTransactionObserver {
    
    let productID = "com.londonappbrewery.InspoQuotes"
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        if isPurchased() {
            showPremiumQuotes()
        }
        SKPaymentQueue.default().add(self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1
        }
       
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        }
        else {
            cell.textLabel?.text = "Get more quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.7206780314, blue: 1, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    
    
    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK: - In-App purchase methods
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {//Checks for parental control
            //Can make payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID//for this particular app, request to apple server
            SKPaymentQueue.default().add(paymentRequest)//auto work will perform here by apple server
            
        } else {
            //Can't make payments
            print("User can't make payments")
        }
        
    }
    
    //Transection condition will check here and kind to notify user
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transection in transactions {
            if transection.transactionState == .purchased {
                //User payment successful
                print("Transection Successful")
                showPremiumQuotes()
                //After successful stop transection process
                SKPaymentQueue.default().finishTransaction(transection)
           
            } else if transection.transactionState == .failed {
                if let error = transection.error {
                    let errorDescription = error.localizedDescription
                    //user payment failed
                    print("Transection failed due to error \(errorDescription)")
                }
                //After successful stop transection process
                SKPaymentQueue.default().finishTransaction(transection)
            }
            else if transection.transactionState == .restored {
                showPremiumQuotes()
                print("Transection restored!")
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transection)
            }
            
        }
    }
    
    
    //MARK: - Premium feature
    
    func showPremiumQuotes() {
        UserDefaults.standard.set(true, forKey: productID)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchasedStatus = UserDefaults.standard.bool(forKey: productID)
        if purchasedStatus {
            print("Previously purchased")
            return true
        }
        else {
            print("Never purchases")
            return false
        }
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }


}
