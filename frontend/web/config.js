 const CONFIG = {
  contractAddress: "0xd7640A41ebcE8d9f01871003AF3FF4A2f0CDFFA1",
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
