// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

contract ParametricCropInsurance is FunctionsClient, ConfirmedOwner {
	
	bytes32 public donID;
	uint64 public subscriptionId;
	uint32 public gasLimit = 300_000;

	address public farmer;
	uint256 public premiumCollected;
	uint256 public coverageAmount;
	uint256 public rainfallThreshold;
	uint256 public measuredRainfall;
	bool public payoutTriggered;

	event PolicyPurchased(address indexed farmer, uint256 premium, uint256 coverage, uint256 threshold);
	event RainfallChecked(uint256 totalRainfallMm);
	event PayoutTriggered(address indexed farmer, uint256 amount);

	constructor(address router, bytes32 _donID, uint64 _subscriptionId) 
	FunctionsClient(router)
	ConfirmedOwner(msg.sender)
	{
		donID = _donID;
		subscriptionId = _subscriptionId;
	}	


	function buyPolicy(uint256 _coverageAmount, uint256 _threshold) external payable {
		require(farmer == address(0), "Policy already active");
		require(msg.value >= _coverageAmount / 10, "Premium too low (min 10 %)");

		farmer = msg.sender;
		premiumCollected += msg.value;
		coverageAmount = _coverageAmount;
		rainfallThreshold = _threshold;

		emit PolicyPurchased(msg.sender, msg.value, _coverageAmount, _threshold);
		
	}

	function fundPayout() external payable onlyOwner {}

	function checkRainfallPeriod(
		bytes memory javascriptSource,
		string calldata startDate,
		string calldata endDate
	) external onlyOwner {
		require(farmer != address(0), "No active policy");

		FunctionsRequest.Request memory req;
		req.initializeRequest(
			FunctionsRequest.Location.Inline,
			FunctionsRequest.CodeLanguage.JavaScript,
			"1.0.0",
			javascriptSource,
			""
		);
		string[] memory args = new string[](2);
		args[0] = startDate;
		args[1] = endDate;
		req.addArgs(args);

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

	}


