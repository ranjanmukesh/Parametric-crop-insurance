// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract ParametricCropInsurance is FunctionsClient, ConfirmedOwner, AutomationCompatibleInterface {
	using FunctionsRequest for FunctionsRequest.Request;	
	string public jsSource;
	bytes32 public donID;
	uint64 public subscriptionId;
	uint32 public gasLimit = 300_000;

	address public farmer;
	uint256 public premiumCollected;
	uint256 public coverageAmount;
	uint256 public rainfallThreshold;
	uint256 public measuredRainfall;
	bool public payoutTriggered;

	uint256 public lastChecked;
	uint256 public checkInterval = 1 days;
	string public seasonStart;
	string public seasonEnd;
	uint256 public seasonStartTimestamp;
	uint256 public seasonEndTimestamp;

	event PolicyPurchased(address indexed farmer, uint256 premium, uint256 coverage, uint256 threshold);
	event RainfallChecked(uint256 totalRainfallMm);
	event PayoutTriggered(address indexed farmer, uint256 amount);

	constructor(address router, bytes32 _donID, uint64 _subscriptionId) 
	FunctionsClient(router)
	ConfirmedOwner(msg.sender)
	{
		donID = _donID;
		subscriptionId = _subscriptionId;
		jsSource = "const lat=args[0];const lon=args[1];const startDate=args[2];const endDate=args[3];const url=`https://archive-api.open-meteo.com/v1/archive?latitude=${lat}&longitude=${lon}&start_date=${startDate}&end_date=${endDate}&daily=precipitation_sum&timezone=Asia%2FKolkata`;const requestConfig={url:url,method:'GET',headers:{'Content-Type':'application/json'}};const response=await Functions.makeHttpRequest(requestConfig);if(response.error){throw Error(`Request failed: ${response.error}`);}const data=response.data;if(!data||!data.daily||!data.daily.precipitation_sum){throw Error('No precipitation data returned');}const rainfallArray=data.daily.precipitation_sum;let totalRainfall=0;for(let i=0;i<rainfallArray.length;i++){totalRainfall+=rainfallArray[i];}return Functions.encodeUint256(Math.round(totalRainfall));";
		
	}	


	function buyPolicy(uint256 _coverageAmount, uint256 _threshold,
		   string calldata _seasonStart,
		   string calldata _seasonEnd,
		   uint256 _seasonStartTimestamp,
		   uint256 _seasonEndTimestamp) external payable {
		require(farmer == address(0), "Policy already active");
		require(msg.value >= _coverageAmount / 10, "Premium too low (min 10 %)");

		farmer = msg.sender;
		premiumCollected += msg.value;
		coverageAmount = _coverageAmount;
		rainfallThreshold = _threshold;
		seasonStart = _seasonStart;
		seasonEnd = _seasonEnd;
		seasonStartTimestamp = _seasonStartTimestamp;
		seasonEndTimestamp = _seasonEndTimestamp;
		lastChecked = block.timestamp;

		emit PolicyPurchased(msg.sender, msg.value, _coverageAmount, _threshold);
		
	}

	function fundPayout() external payable onlyOwner {}

	function checkRainfallPeriod(
		string calldata javascriptSource,
		string calldata startDate,
		string calldata endDate
	) public onlyOwner {
		require(farmer != address(0), "No active policy");

		FunctionsRequest.Request memory req;
		req.initializeRequest(
			FunctionsRequest.Location.Inline,
			FunctionsRequest.CodeLanguage.JavaScript,
			javascriptSource
		);
		string[] memory args = new string[](2);
		args[0] = startDate;
		args[1] = endDate;
		req.setArgs(args);

		_sendRequest(req.encodeCBOR(), subscriptionId, gasLimit, donID);
	}

	function fulfillRequest(bytes32, bytes memory response, bytes memory) internal override {
		measuredRainfall = abi.decode(response, (uint256));
		emit RainfallChecked(measuredRainfall);

		if(measuredRainfall < rainfallThreshold && !payoutTriggered){

			payoutTriggered = true;
			uint256 payout = coverageAmount;
			require(address(this).balance >= payout, "Insufficient Funds");
			payable(farmer).transfer(payout);
			emit PayoutTriggered(farmer, payout);
			
		}
	}

	function withdrawProfits() external onlyOwner{
		payable(owner()).transfer(address(this).balance);
	}

	function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory){
		upkeepNeeded = (farmer != address(0)) &&
		(block.timestamp >= lastChecked + checkInterval) &&
		(block.timestamp >= seasonStartTimestamp) &&
		(block.timestamp <= seasonEndTimestamp);
		return (upkeepNeeded, "");
	}

	function performUpkeep(bytes calldata) external override{
		(bool upkeepNeeded, ) = this.checkUpkeep("");
		require(upkeepNeeded, "Upkeep not needed");
		checkRainfallPeriod(jsSource,seasonStart, seasonEnd);
		lastChecked = block.timestamp;
	}

	function isInSeason() internal view returns (bool) {
		return block.timestamp >= seasonStartTimestamp && 
		block.timestamp <= seasonEndTimestamp;
	}
	}


