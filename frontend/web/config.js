 const CONFIG = {
  desiredChainId: 8453,
  contractAddress: "0x55C6E9047205aE8457F624390FCa4236EED07527",
  packages: {
    low: {
      name: "Low Protection",
      coverage: ethers.parseEther("0.001"),
      droughtThreshold: 650n,
      excessRainThreshold: 1600n,
      premiumRate: 0.10
    },
    medium: {
      name: "Medium Protection",
      coverage: ethers.parseEther("0.002"),
      droughtThreshold: 750n,
      excessRainThreshold: 1400n,
 
      premiumRate:0.13
    },
    high: {
      name: "High Protection",
      coverage: ethers.parseEther("0.003"),
      droughtThreshold: 850n,
      excessRainThreshold: 1250n,
      premiumRate: 0.16
    }
  }
  };
