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

We welcome contributions! Whether you want to fix a bug, improve the frontend, add new features (e.g. multi-crop support, better oracle integration), or help with pilots — this guide will help you get started quickly.

### Prerequisites

-  Git
-  Node.js (v20 or higher)
-  Foundry (latest stable) 
-  MetaMask (for testing the frontend)
-  A Base Sepolia (testnet) or Base Mainnet wallet with some ETH for deployment/testing

### Project Structure

```
.
├── contracts/              # Solidity smart contracts + deployment scripts
│   ├── src/
│   ├── script/
│   └── test/
├── frontend/               # Static HTML + JS dApp (no build step required)
│   └── web/
│       ├── index.html
│       ├── config.js
│       ├── abi.json
│       └── ...
├── test/                   # Foundry tests
├── lib/                    # Git submodules (forge-std, chainlink)
├── foundry.toml
└── README.md
```

### Quick Local Setup (CI-Aligned)

1. Clone the repository

```
 git clone https://github.com/ranjanmukesh/Parametric-crop-insurance.git

cd Parametric-crop-insurance

```

2. Install frontend dependencies

```
 cd frontend
npm install
cd ..

```
3. Install Chainlink contracts (same as CI)

```
 npm install @chainlink/contracts --no-save

```
4. Create symlink for Foundry (matches CI step)

```
 rm -rf lib/chainlink lib/forge-stt
mkdir -p lib/chainlink/contracts
ln -s $(pwd)/node_modules/@chainlink/contracts lib/chainlink/contracts
 
```

5. Build and test the smart contracts

```
 forge clean
forge build --sizes
forge test -vvv

```
6. Deploy

```
forge script contracts/script/DeployInsurance.s.sol:DeployInsurance \
            --rpc-url $RPC_URL \
            --private-key $PRIVATE_KEY \
            --broadcast \
            --verify \
            --etherscan-api-key $SCAN_API_KEY \

 
```
Change RPC_URL, PRIVATE_KEY and SCAN_API_KEY as required

7.  Running the Frontend

Edit frontend/web/config.js to update desiredChainId and contractAddress.

Update ABI after changing the smart contract:

```
jq '.abi' out/ParametricCropInsurance.sol/ParametricCropInsurance.json > frontend/web/abi.json

```


 The frontend is a single static HTML file. Simply open frontend/web/index.html in your browser (or we normally use browser inside metamask ).


## Need Help?
-  Open an issue (use labels: bug, enhancement, question, or help wanted)
-  Contact: Mukesh Ranjan — paramora@proton.me


We are actively seeking partnerships with FPOs, KVKs, SFAC, and other agricultural organizations for pilots in Maharashtra and Hawaii.

---

**Built with ❤️ for climate-resilient agriculture**

*Transparency • Automation • Trust*
