// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";


contract ParametricCropInsurance is FunctionsClient, ConfirmedOwner {
	using FunctionsRequest for FunctionsRequest.Request;	
  struct Policy{
    uint256  coverageAmount;
    uint256 droughtThreshold;
    uint256 excessRainThreshold;
    uint256 expectedRainfall;
    uint256 measuredRainfall;
    uint256 rainfallIndex;
    bool  payoutTriggered;
    uint256  lastChecked;
    uint256  checkInterval;
    string  seasonStart;
    string  seasonEnd;
    uint256  seasonStartTimestamp;
    uint256  seasonEndTimestamp;
    string lat;
    string long;
  }
	struct MigratablePolicy {
    uint256 coverageAmount;
    uint256 droughtThreshold;
    uint256 excessRainThreshold;
    uint256 expectedRainfall;
    uint256 measuredRainfall;
    uint256 rainfallIndex;
    bool payoutTriggered;
    uint256 lastChecked;
    uint256 checkInterval;
    string seasonStart;
    string seasonEnd;
    uint256 seasonStartTimestamp;
    uint256 seasonEndTimestamp;
    string lat;
    string long;
}
  uint256 public totalPremiumCollected;
	string public jsSource;
	bytes32 public donID;
	uint64 public subscriptionId;
	uint32 public gasLimit = 300_000;
  uint256 public defaultCheckInterval = 1 days;
  uint8 public minPremiumPercent = 10;
  address[] public activeFarmers;
  mapping(address => uint256) public farmerIndex;

  mapping(address => Policy) public policies;
  mapping(bytes32 => address) public requestToFarmer;
  mapping(address => bool) public invitedFarmers;
	event PolicyPurchased(
    address indexed farmer, 
    uint256 premium, 
    uint256 coverage, 
    uint256 droughtThreshold,
    uint256 excessRainThreshold,
    uint256 expectedRainfall,
    string seasonStart,
    string seasonEnd
    );
	event RainfallChecked(uint256 totalRainfallMm);
	event PayoutTriggered(address indexed farmer, uint256 amount);
  event FarmerInvited(address indexed inviter, address indexed invitee);

  event RequestFailed(bytes32 indexed requestId, string errorMessage);
  event SubscriptionIdUpdated(uint64 oldId, uint64 newId);
  event DonIdUpdated(bytes32 oldDonId, bytes32 newDonId);
  event GasLimitUpdated(uint32 oldGasLimit, uint32 newGasLimit);
  event JsSourceUpdated(string oldSource, string newSource);
  event DefaultCheckIntervalUpdated(uint256 oldInterval, uint256 newInterval);
  event MinPremiumPercentUpdated(uint8 oldPercent, uint8 newPercent);
  event EmergencyMigration(address indexed newContract, uint256 totalFundsMigrated, uint256 farmersMigrated);

	constructor(address router, bytes32 _donID, uint64 _subscriptionId) 
	FunctionsClient(router)
	ConfirmedOwner(msg.sender)
	{
		donID = _donID;
		subscriptionId = _subscriptionId;
		jsSource = "const lat=args[0];const lon=args[1];const startDate=args[2];const endDate=args[3];const url=`https://archive-api.open-meteo.com/v1/archive?latitude=${lat}&longitude=${lon}&start_date=${startDate}&end_date=${endDate}&daily=precipitation_sum&timezone=Asia%2FKolkata`;const requestConfig={url:url,method:'GET',headers:{'Content-Type':'application/json'}};const response=await Functions.makeHttpRequest(requestConfig);if(response.error){throw Error(`Request failed: ${response.error}`);}const data=response.data;if(!data||!data.daily||!data.daily.precipitation_sum){throw Error('No precipitation data returned');}const rainfallArray=data.daily.precipitation_sum;let totalRainfall=0;for(let i=0;i<rainfallArray.length;i++){totalRainfall+=rainfallArray[i];}return Functions.encodeUint256(Math.round(totalRainfall));";
		
	}	

  function setSubscriptionId(uint64 _newSubscriptionId) external onlyOwner {
    require(_newSubscriptionId != 0, "Invalid subscription ID");
    uint64 oldId = subscriptionId;
    subscriptionId = _newSubscriptionId;
    emit SubscriptionIdUpdated(oldId, _newSubscriptionId);
  }


  function setDonId(bytes32 _newDonId) external onlyOwner {
    require(_newDonId != bytes32(0), "Invalid DON ID");
    bytes32 oldDonId = donID;
    donID = _newDonId;
    emit DonIdUpdated(oldDonId, _newDonId);
  }

  function setGasLimit(uint32 _newGasLimit) external onlyOwner {
    require(_newGasLimit >= 100000 && _newGasLimit <= 500000, "Gas limit must be between 100k and 500k");
    uint32 oldGasLimit = gasLimit;
    emit GasLimitUpdated(oldGasLimit, _newGasLimit);
  }

  function setJsSource(string memory _newJsSource) external onlyOwner{
    string memory oldSource = jsSource;
    jsSource = _newJsSource;
    emit JsSourceUpdated(oldSource, _newJsSource);
  }

  function setDefaultCheckInterval(uint256 _newInterval) external onlyOwner {
    require(_newInterval >= 1 hours && _newInterval <= 30 days, "interval out of range");
    uint256 oldInterval = defaultCheckInterval;
    defaultCheckInterval = _newInterval;
    emit DefaultCheckIntervalUpdated(oldInterval, _newInterval);
  }

  function setMinPremiumPercent(uint8 _newPercent) external onlyOwner {
    require(_newPercent >= 5 && _newPercent <= 50, "Percent must be 5-50");
    uint8 old = minPremiumPercent;
    minPremiumPercent = _newPercent;
    emit MinPremiumPercentUpdated(old, _newPercent);
  }

	function buyPolicy(
       uint256 _coverageAmount,
       uint256 _droughtThreshold,
       uint256 _excessRainThreshold,
       uint256 _expectedRainfall,
		   string calldata _seasonStart,
		   string calldata _seasonEnd,
		   uint256 _seasonStartTimestamp,
		   uint256 _seasonEndTimestamp,
       string calldata _lat,
       string calldata _long) external payable {
    require(invitedFarmers[msg.sender], "Only invited farmers can purchase a policy");
    require(policies[msg.sender].seasonStartTimestamp == 0, "Policy already active");
		require(msg.value >= _coverageAmount / 10, "Premium too low (min 10 %)");

    Policy storage policy = policies[msg.sender];
    totalPremiumCollected += msg.value;
    policy.coverageAmount = _coverageAmount;
    policy.droughtThreshold = _droughtThreshold; 
    policy.excessRainThreshold = _excessRainThreshold;
    policy.expectedRainfall = _expectedRainfall;
    policy.seasonStart = _seasonStart;
    policy.seasonEnd = _seasonEnd;
    policy.seasonStartTimestamp = _seasonStartTimestamp;
    policy.seasonEndTimestamp = _seasonEndTimestamp;
    policy.lastChecked = block.timestamp;
    policy.checkInterval = defaultCheckInterval;
    policy.lat = _lat;
    policy.long = _long;

    activeFarmers.push(msg.sender);
    farmerIndex[msg.sender] = activeFarmers.length;

		emit PolicyPurchased(
      msg.sender, 
      msg.value, 
      _coverageAmount, 
      _droughtThreshold,
      _excessRainThreshold,
      _expectedRainfall,
      _seasonStart,
      _seasonEnd
      );
		
	}

  function inviteFarmer(address _newFarmer) external {
    require(farmerIndex[msg.sender] != 0 || msg.sender == owner(), "Only farmers or the owners can invite");
    require(_newFarmer != address(0), "invalid farmer address");
    require(policies[_newFarmer].seasonStartTimestamp == 0, "Farmer already has an active policy");
    invitedFarmers[_newFarmer] = true;
    emit FarmerInvited(msg.sender, _newFarmer);
  }

  function _removeFromActive(address _farmer) internal {
    uint256 index = farmerIndex[_farmer];
    if (index == 0) return;

    uint256 lastIndex = activeFarmers.length - 1;
    address lastFarmer = activeFarmers[lastIndex];
    activeFarmers[index-1] = lastFarmer;
    farmerIndex[lastFarmer] = index;

    activeFarmers.pop();

    delete farmerIndex[_farmer];
  }

	function fundPayout() external payable onlyOwner {}

	function checkRainfallForFarmer(
    address _farmer,
    string memory startDate,
		string memory endDate
	)  public onlyOwner {
    _checkRainfallPeriod(_farmer,jsSource,startDate. endDate);
	}


	function _checkRainfallPeriod(
    address _farmer,
    string memory javascriptSource,
		string memory startDate,
		string memory endDate
	) internal {
    Policy storage policy = policies[_farmer];
    require(policy.seasonStartTimestamp != 0, "No active policy");
		FunctionsRequest.Request memory req;
		req.initializeRequest(
			FunctionsRequest.Location.Inline,
			FunctionsRequest.CodeLanguage.JavaScript,
			javascriptSource
		);
		string[] memory args = new string[](4);
		args[0] = policy.lat;
		args[1] = policy.long;
		args[2] = startDate;
		args[3] = endDate;
		req.setArgs(args);

		bytes32 requestId = _sendRequest(req.encodeCBOR(), subscriptionId, gasLimit, donID);
    requestToFarmer[requestId] = _farmer;
	}

	function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory err) internal override {
    address farmerAddr = requestToFarmer[requestId];
    require(farmerAddr != address(0), "Unknown request");
    if(err.length > 0) {
      emit RequestFailed(requestId, string(err));
      delete requestToFarmer[requestId];
      return;
    }
    Policy storage policy = policies[farmerAddr];
		policy.measuredRainfall = abi.decode(response, (uint256));
		emit RainfallChecked(policy.measuredRainfall);
    if(policy.expectedRainfall == 0){
      delete requestToFarmer[requestId];
      return;
    }

    policy.rainfallIndex = (policy.measuredRainfall * 1000) / policy.expectedRainfall;
    bool shouldPayout = false;
    uint256 payoutAmount = 0;
    if (policy.rainfallIndex < policy.droughtThreshold && !policy.payoutTriggered){
      shouldPayout = true;
      uint256 factor = (policy.droughtThreshold - policy.rainfallIndex) * 1000 / (policy.droughtThreshold * 750);
      payoutAmount = (policy.coverageAmount * factor) / 1000;
    }
    else if (policy.rainfallIndex > policy.excessRainThreshold && !policy.payoutTriggered){
      shouldPayout = true;
      uint256 factor = (policy.rainfallIndex - policy.excessRainThreshold) * 1000 / ((2000 - policy.excessRainThreshold)*750);
      payoutAmount = (policy.coverageAmount * factor) / 1000;
    }
		if(shouldPayout){
      if (payoutAmount > policy.coverageAmount) payoutAmount = policy.coverageAmount;

			policy.payoutTriggered = true;
			uint256 payout = policy.coverageAmount;
			require(address(this).balance >= payout, "Insufficient Funds");
			payable(farmerAddr).transfer(payout);
			emit PayoutTriggered(farmerAddr, payout);
		  _removeFromActive(farmerAddr);	
		}
    delete requestToFarmer[requestId];
	}

	function withdrawProfits() external onlyOwner{
		payable(owner()).transfer(address(this).balance);
	}

  function requestMyRainfallCheck() external {
    Policy storage policy = policies[msg.sender];
    require(policy.seasonStartTimestamp != 0, "No active policy");
    require(block.timestamp >= policy.lastChecked + policy.checkInterval, "Too soon");
    require(block.timestamp >= policy.seasonStartTimestamp && block.timestamp <= policy.seasonEndTimestamp, "Not in season");
    _checkRainfallPeriod(msg.sender,jsSource, policy.seasonStart, policy.seasonEnd);
    policy.lastChecked = block.timestamp;
  }
	

  function getPolicy(address _farmer) external view returns (Policy memory){
    return policies[_farmer];
  }
	function emergencyMigrateToNewContract(address newContract) external onlyOwner {
    require(newContract != address(0), "Invalid new contract address");
    require(newContract != address(this), "Cannot migrate to self");

    uint256 totalBalance = address(this).balance;
    uint256 farmersMigrated = 0;

    // 1. Migrate all active farmers' policies
    for (uint256 i = 0; i < activeFarmers.length; i++) {
        address farmer = activeFarmers[i];
        Policy storage oldPolicy = policies[farmer];

        if (oldPolicy.seasonStartTimestamp == 0) continue; // skip inactive

        // Create migratable snapshot
        MigratablePolicy memory mp = MigratablePolicy({
            coverageAmount: oldPolicy.coverageAmount,
            droughtThreshold: oldPolicy.droughtThreshold,
            excessRainThreshold: oldPolicy.excessRainThreshold,
            expectedRainfall: oldPolicy.expectedRainfall,
            measuredRainfall: oldPolicy.measuredRainfall,
            rainfallIndex: oldPolicy.rainfallIndex,
            payoutTriggered: oldPolicy.payoutTriggered,
            lastChecked: oldPolicy.lastChecked,
            checkInterval: oldPolicy.checkInterval,
            seasonStart: oldPolicy.seasonStart,
            seasonEnd: oldPolicy.seasonEnd,
            seasonStartTimestamp: oldPolicy.seasonStartTimestamp,
            seasonEndTimestamp: oldPolicy.seasonEndTimestamp,
            lat: oldPolicy.lat,
            long: oldPolicy.long
        });

        // Call the new contract's migration receiver
        // The new contract must implement receiveMigratedPolicy(address, MigratablePolicy)
        (bool success, ) = newContract.call(
            abi.encodeWithSignature(
                "receiveMigratedPolicy(address,(uint256,uint256,uint256,uint256,uint256,uint256,bool,uint256,uint256,string,string,uint256,uint256,string,string))",
                farmer,
                mp
            )
        );

        require(success, "Failed to migrate policy");

        farmersMigrated++;
        
        // Optional: Clear old policy to prevent double-claiming (safer)
        delete policies[farmer];
    }

    // 2. Send ALL Ether to the new contract
    if (totalBalance > 0) {
        (bool sent, ) = newContract.call{value: totalBalance}("");
        require(sent, "Failed to send funds");
    }

    // 3. Clear active farmers list (contract is now deprecated)
    delete activeFarmers;

    emit EmergencyMigration(newContract, totalBalance, farmersMigrated);
}
}
