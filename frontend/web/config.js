 const CONFIG = {
  desiredChainId: 11155111,
  contractAddress: "0x49743DA10682610E9a4B6B4B5AdCa647d527818a",
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
