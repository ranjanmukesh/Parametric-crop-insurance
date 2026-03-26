// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/ParametricCropInsurance.sol";

contract ParametricCropInsuranceTest is Test {
  ParametricCropInsurance public insurance;
  address public owner = makeAddr("owner");
  address public farmer = makeAddr("farmer");

  uint256 constant COVERAGE_AMOUNT = 1000 ether;
  uint256 constant PREMIUM = 100 ether;
  uint256 constant RAINFALL_THRESHOLD = 500;
  string constant SEASON_START = "2025-06-01";
  string constant SEASON_END = "2025-09-30";
  uint256 constant START_TS = 1748736000;
  unit256 constant END_TS = 1759276800;

  function setUp() public {
    vm.prank(owner);
    insurance = new ParametricCropInsurance(
    address(0x123),
    bytes32(0),
    1
);
  vm.deal(address(insurance), 5000 ether);
  }

  function test_BuyPolicy_Success() public {
    vm.deal(farmer, PREMIUM);
    vm.prank(farmer);
    
    insurance.buyPolicy{value: PREMIUM}(
      COVERAGE_AMOUNT,
      RAINFALL_THRESHOLD,
      SEASON_START,
      SEASON_END,
      START_TS,
      END_TS
    );
    ParametricCropInsurance.Policy memory policy = insurance.policies(farmer);

    assertEq(policy.coverageAmount, COVERAGE_AMOUNT);
    assertEq(policy.rainfallThreshold, RAINFALL_THRESHOLD);
    assertEq(policy.seasonStart, SEASON_START);
    assertEq(policy.seasonEnd, SEASON_END);
    assertEq(policy.seasonStartTimestamp, START_TS);
    assertEq(policy.seasonEndTimestamp, END_TS);
    assertFalse(policy.payoutTriggered);
    assertEq(policy.measuredRainfall, 0);
    assertGt(policy.lastChecked, 0);
    assertEq(policy.checkInterval, 1 days);
    assertEq(insurance.totalPremiumCollected(), PREMIUM);


  }
}

