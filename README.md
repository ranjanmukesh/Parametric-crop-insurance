# Parametric Crop Insurance dApp

A decentralized parametric crop insurance platform built with **Chainlink Functions** and **Chainlink Automation** (CRE workflow) on **Base Sepolia testnet**. Farmers can purchase policies that automatically pay out if monsoon rainfall in Maharashtra falls below a critical threshold (e.g., drought conditions), using real-world weather data fetched via Chainlink oracles.

This project solves real-world challenges for smallholder farmers in India by providing transparent, tamper-proof, and instant payouts—no claims adjusters or paperwork required. Built as an entry for the **Chainlink Convergence Hackathon** (February–March 2026).

### Key Features
- **Parametric Trigger**: Payouts based on objective rainfall data (total mm during monsoon season) fetched from Open-Meteo API via Chainlink Functions.
- **Smart Contract**: Solidity contract handles policy purchase, premium collection, funding, and auto-payouts.
- **Off-Chain Compute**: JavaScript source code aggregates historical rainfall data securely.
- **Monetization Potential**: 5–10% premium fees collected by the protocol/insurer; high demand in Maharashtra agri regions.
- **Future Enhancements**: Chainlink Automation for seasonal auto-checks, multi-farmer support, frontend dashboard, cross-chain via CCIP.

### Why Chainlink?
- **Functions**: Securely pulls and computes custom weather data off-chain.
- **CRE Runtime**: Orchestrates oracles, automation, and cross-chain potential.
- **Proven Reliability**: Tamper-proof data ensures trust in payouts.

### Tech Stack
- Solidity ^0.8.19 (EVM-compatible)
- Chainlink Contracts: FunctionsClient, ConfirmedOwner
- Foundry (forge) for development, testing, deployment
- Polygon Amoy testnet (low fees, full Chainlink Functions support)
- Open-Meteo API (free historical weather data)

### Demo / Live Contract
- Deployed on Polygon Amoy: [Insert contract address after deployment]
- Chainlink Functions Subscription: [Insert your sub ID]
- Testnet Explorer: https://sepolia.basescan.org/address/0x120138859857Bd972B7AD56165e43D267C4521eb

### Quick Start (Local Development)
1. **Prerequisites**
   - Foundry installed (`curl -L https://foundry.paradigm.xyz | bash && foundryup`) 
   - MetaMask + Base Sepolia testnet (test ETH from https://faucet.base.org or others)
   - Chainlink Functions subscription on Base Sepolia[](https://functions.chain.link/base-sepolia) + test LINK from https://faucet.chain.link (select Base Sepolia)

2. **Clone & Setup**
	    ```bash
	       git clone https://github.com/[your-username]/parametric-crop-insurance.git
	          cd parametric-crop-insurance
		     forge install

3. **Environment**
Create .env:
```
PRIVATE_KEY=0xYourTestnetPrivateKey
RPC_URL=https://sepolia.base.org  # Or use Alchemy/Infura for faster RPC
```
3. **Build & Test**

```
forge build

forge test -vvv
```

4. **Deploy**

```
source .env

forge script script/DeployInsurance.s.sol --rpc-url $RPC_URL --broadcast --verify -vvvvNote the deployed address!
```

5. **Interact (via cast or Basescan)**

 - Fund contract (send test ETH as owner).
 - Buy policy: buyPolicy(uint256 coverageAmount, uint256 rainfallThreshold) (send premium ETH).
 - Trigger check: checkRainfallPeriod(bytes javascriptSource, string startDate, string endDate) (encode JS source first).

 ## License
 This project is licensed under the MIT License - see the [LICENSE](https://github.com/ranjanmukesh/Parametric-crop-insurance/blob/main/LICENSE.md) file for details.
