 const CONFIG = {
  contractAddress:"0x0e5521cb300C2Ffe2A44aCdf3bc5EF85CDa4e5c5",
  packages: {
    low: {
      name: "Low Protection",
      coverage: ethers.parseEther("0.5"),
      threshold: 120,
      premiumRate: 0.12
    },
    medium: {
      name: "Medium Protection",
      coverage: ethers.parseEther("1.0"),
      threshold: 80,
      premiumRate:0.11
    },
    high: {
      name: "High Protection",
      coverage: ethers.parseEther("2.0"),
      threshold: 50,
      premiumRate: 0.10
    }
  }
  };
