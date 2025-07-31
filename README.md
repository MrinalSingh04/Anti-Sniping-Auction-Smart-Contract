# 🕒 Anti-Sniping Auction Smart Contract

A Solidity smart contract for running fair auctions that **prevents last-second sniping** by extending the auction deadline when bids are placed close to the end time.

---

## 🔍 What is This? 

This project implements a decentralized auction system that includes:

- ⏱ **Anti-sniping mechanism** — Extends the auction end time if a bid is placed just before the deadline.
- 🎯 **Reserve price** — The auction only considers valid bids above a specified minimum.
- 📈 **Minimum bid increment** — Each new bid must be higher by a certain threshold.
- 💸 **Bid refunding** — Losing bidders can safely withdraw their previous bids.

---

## 🎯 Why Build This?

In traditional and on-chain auctions, last-second bidders ("snipers") can unfairly win by placing a bid moments before the auction ends — giving no time for counter-bids.

This contract **prevents sniping** by auto-extending the auction if a bid is placed within the last `X` seconds (default: 1 minute). This makes the auction more **transparent**, **fair**, and **competitive**, especially in high-value scenarios like NFT drops or rare item auctions.

---

## 🛠 Tech Stack

- **Solidity 0.8.24**
- **Foundry** for local testing, scripting, and deployment
- **Anvil** for simulating a local blockchain

---

## 🚀 Features

- ✅ Fair anti-sniping auction logic
- ✅ Configurable reserve price and bid increment
- ✅ Fully tested using Foundry
- ✅ Refunds for previous highest bidders
- ✅ Easy to deploy locally or on any EVM chain

---

## 📦 Project Structure

anti-sniping-auction/
├── src/
│   └── AntiSnipingAuction.sol       # Main contract
├── test/
│   └── AntiSnipingAuction.t.sol     # Foundry tests
├── script/
│   └── DeployAuction.s.sol          # Local deploy script
├── foundry.toml
└── README.md                        # You are here

---

## 🧠 License

MIT License — open-source and free to use for both educational and commercial purposes.

## 🤝 Contribute / Fork

Feel free to fork, suggest improvements, or open issues! This project is a great base for:

NFT marketplace auctions
Rare asset token sales
Time-extended fundraising events
