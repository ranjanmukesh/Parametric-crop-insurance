 const CONFIG = {
  contractAddress: "0xe39e6577Ed0F8A3E79a23DaF871e4cEDB72c0f85",
  packages: {
    low: {
      name: "Low Protection",
      coverage: ethers.parseEther("0.5"),
      droughtThreshold: 650n,
      excessRainThreshold: 1600n,
      premiumRate: 0.10
    },
    medium: {
      name: "Medium Protection",
      coverage: ethers.parseEther("1.0"),
      droughtThreshold: 750n,
      excessRainThreshold: 1400n,
 
      premiumRate:0.13
    },
    high: {
      name: "High Protection",
      coverage: ethers.parseEther("2.0"),
      droughtThreshold: 850n,
      excessRainThreshold: 1250n,
      premiumRate: 0.16
    }
  }
  };
