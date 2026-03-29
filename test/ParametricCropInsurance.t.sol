// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/src/ParametricCropInsurance.sol";

contract ParametricCropInsuranceHarness is ParametricCropInsurance {
  constructor(address router, bytes32 _donID, uint64 _subscriptionId)
  ParametricCropInsurance(router, _donID, _subscriptionId)
  {}

  function fulfillRequestTest(
    bytes32 requestId,
    bytes memory response,
    bytes memory err
  ) external { 
    super.fulfillRequest(requestId, response, err);
    } 
  } 

contract MockFunctionsRouter 
{ 
  address public lastConsumer; 
  bytes public lastEncodedRequest; 
  uint64 public lastSubscriptionId; 
  uint32 public lastGasLimit; 
  bytes32 public lastDonId; 
  bytes public simulatedResponse = abi.encode(uint256(420)); 
  bytes public simulatedErr;

function sendRequest(
  bytes calldata data,
  uint64 subscriptionId,
  uint32 gasLimit,
  bytes32 donId
) external returns (bytes32) {
  lastConsumer = msg.sender;
  lastEncodedRequest = data;
  lastSubscriptionId = subscriptionId;
  lastGasLimit = gasLimit;
  lastDonId = donId;
    
  bytes32 requestId = keccak256(abi.encode(block.timestamp, msg.sender, data));

  ParametricCropInsuranceHarness(msg.sender).fulfillRequestTest(
    requestId,
    simulatedResponse,
    simulatedErr
    ); 
  return requestId;

  }
  
  function setSimulatedResponse( bytes memory response, bytes memory err) external {
    simulatedResponse = response;
    simulatedErr = err;
  }
}

contract ParametricCropInsuranceTest is Test {
  ParametricCropInsuranceHarness public insurance;
  MockFunctionsRouter public mockRouter;
  address public owner = makeAddr("owner");  
  address public farmer = makeAddr("farmer");

  uint256 constant COVERAGE_AMOUNT = 1000 ether;
  uint256 constant PREMIUM = 100 ether;
  uint256 constant RAINFALL_THRESHOLD = 500;
  string constant SEASON_START = "2025-06-01";
  string constant SEASON_END = "2025-09-30";
  uint256 constant START_TS = 1748736000;
  uint256 constant END_TS = 1759276800;

  function setUp() public {
    mockRouter = new MockFunctionsRouter();
    vm.startPrank(owner);
    insurance = new ParametricCropInsuranceHarness(
    address(mockRouter),
    bytes32(0),
    1
);
  vm.stopPrank();
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
    ParametricCropInsurance.Policy memory policy = insurance.getPolicy(farmer);

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


  function test_CheckRainfallPeriod_ChainlinkFunctions_Success() public {
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

    vm.startPrank(owner);
    insurance.checkRainfallPeriod(
      farmer,
      insurance.jsSource(),
      SEASON_START,
      SEASON_END
    );
    vm.stopPrank();

    assertEq(mockRouter.lastGasLimit(), insurance.gasLimit());
    assertEq(mockRouter.lastDonId(), bytes32(0));

    ParametricCropInsurance.Policy memory policy = insurance.getPolicy(farmer);

    assertEq(policy.measuredRainfall, 420);
    assertTrue(policy.payoutTriggered);

    assertEq(address(farmer).balance, PREMIUM + COVERAGE_AMOUNT);
  }
}

