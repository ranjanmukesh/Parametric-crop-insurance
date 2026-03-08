// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import "../src/ParametricCropInsurance.sol";
import {console} from "forge-std/console.sol";

contract DeployInsurance is Script {
	function run() external {
//		uint256 deployerKey = vm.envUint("PRIVATE_KEY");

		address router = 0xf9B8fc078197181C841c296C876945aaa425B278;
		bytes32 donId = 0x66756e2d626173652d7365706f6c69612d310000000000000000000000000000;
		uint64 subscriptionId = 123;

		vm.startBroadcast();

		ParametricCropInsurance insurance = new ParametricCropInsurance(
			router,
			donId,
			subscriptionId
		);

		vm.stopBroadcast();

		console.log("Deployed at:", address(insurance));
	}
}
