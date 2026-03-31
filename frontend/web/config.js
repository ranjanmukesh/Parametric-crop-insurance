 const CONFIG = {
  contractAddress: "0x47acec90BF5baD02a81030aF4A48681B04deED4D",
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
