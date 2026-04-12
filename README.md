# Paramora

**Parametric Crop Insurance on Blockchain**  
*Fast • Transparent • Automatic Protection for Smallholder Farmers*

Paramora is a decentralized application (dApp) that delivers **parametric crop insurance** using smart contracts on **Base Mainnet**. It automatically triggers payouts based on rainfall thresholds (drought or excess rain), eliminating paperwork, delays, and low-trust issues common in traditional schemes like PMFBY.

Farmers or Farmer Producer Organizations (FPOs) register via MetaMask. Chainlink oracles monitor real-world weather data from sources like IMD (India Meteorological Department). When predefined triggers are met, the smart contract executes instant ETH payouts with full on-chain transparency.

A live MVP is deployed on Base Mainnet, with pilots planned in Maharashtra (India) and future implementation in Hawaii.

## The Maharashtra Problem

Smallholder farmers in rainfed regions (e.g., Maharashtra's Pune, Baramati, Marathwada, Vidarbha) face heavy losses from erratic rainfall — drought during sowing or excess rain during harvest.

Traditional insurance involves complex claims, long delays, and low trust, leaving many farmers unprotected.

## Our Solution

Paramora uses blockchain, Chainlink oracles, and Automation for **trustless, automatic payouts**. No claims process needed.

- **Live on Base Mainnet** — Low gas fees (~0.05 Gwei) make it affordable.
- **Payouts** in ETH directly to the farmer's registered wallet.
- **Transparent** — Every transaction verifiable on Etherscan.
- **Complements** government schemes rather than replacing them.

## How It Works

1. **Connect MetaMask** → Register a policy with crop + district-specific rainfall triggers.
2. **Chainlink oracles** continuously monitor real-world weather data (IMD/public sources).
3. **Trigger hit** (e.g., rainfall deficit in a critical growth stage) → Smart contract automatically executes the payout in ETH.

## Live Demo

Try the interactive frontend demo here:  
**[https://ranjanmukesh.github.io/Parametric-crop-insurance/frontend/web/index.html](https://ranjanmukesh.github.io/Parametric-crop-insurance/frontend/web/index.html)**

The demo includes:
- Connect Wallet button
- Policy selection (Low / Medium / High protection levels)
- Inputs for coverage amount (ETH), drought & excess rain thresholds (mm), season dates, and farm location (latitude/longitude)
- "Buy Policy Now" functionality
- View active policies with farmer details and payout status
- Invite new farmers feature

This showcases the user flow for purchasing and managing parametric insurance policies.

## Project Goals

- Provide instant, transparent climate risk protection to smallholder farmers.
- Reduce dependency on slow, bureaucratic traditional insurance.
- Build resilience against climate change through automated, verifiable payouts.
- Run no-cost pilots with FPOs, KVKs (Krishi Vigyan Kendras), and SFAC networks.
- Align with national priorities on climate resilience and digital agriculture.
- Explore IRDAI’s Regulatory Sandbox (2025 regulations) for parametric and blockchain-based insurance innovations in India.
- Expand implementation from Maharashtra to regions like Hawaii.

### Pilot Details (Maharashtra)
- **Target**: 100–500 farmers initially.
- We fund the smart contract and cover all payouts during the pilot.
- Simple onboarding with FPO/KVK support (MetaMask wallet setup + optional UPI/bank distribution).
- Full data insights and transparency for partner organizations.

## Key Benefits

- **Farmers**: Instant, trust-based compensation with no paperwork.
- **FPOs / KVKs / SFAC**: Easy value-add service to strengthen member resilience.
- **Technology**: Tamper-proof automation via Base + Chainlink.

## Tech Stack (High-Level)

- **Blockchain**: Base Mainnet (Ethereum L2)
- **Oracles & Automation**: Chainlink
- **Frontend**: Web dApp (MetaMask integration)
- **Smart Contracts**: Automatic trigger-based payouts

(Full smart contract repository and deployment details will be added as the project progresses.)

## Setup & Onboarding Instructions

### For Farmers / Users (Demo / Pilot)
1. Install [MetaMask](https://metamask.io/) browser extension or mobile app.
2. Switch network to **Base Mainnet**.
3. Visit the [live demo](https://ranjanmukesh.github.io/Parametric-crop-insurance/frontend/web/index.html).
4. Click **Connect Wallet** and connect your MetaMask.
5. Select protection level and enter policy details (coverage, thresholds, season, location).
6. Confirm transaction to register the policy.
7. Monitor your policy and receive automatic ETH payouts if triggers are met.

**Note**: During pilots, FPO/KVK representatives can assist with wallet setup and distribution.

### For Developers / Contributors
- Clone the repository (frontend and contracts folders).
- Install dependencies: `npm install` (in frontend directory).
- Run locally: Follow standard React/Vite setup (or whatever framework is used).
- Smart contract deployment scripts and Chainlink oracle integration details are in the `/contracts` folder.

(If you are forking or contributing, please reach out first.)

## Contact

**Mukesh Ranjan**  
Cofounder  
Paramora – Parametric Crop Insurance on Blockchain  
**Email**: paramora@proton.me

We are actively seeking partnerships with FPOs, KVKs, SFAC, and other agricultural organizations for pilots in Maharashtra and Hawaii.

---

**Built with ❤️ for climate-resilient agriculture**

*Transparency • Automation • Trust*
