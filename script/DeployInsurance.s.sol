// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import "../src/ParametricCropInsurance.sol";
import {console} from "forge-std/console.sol";

contract DeployInsurance is Script {
	function run() external {
//		uint256 deployerKey = vm.envUint("PRIVATE_KEY");

		address router = 0xC22a79eBA640940ABB6dF0f7982cc119578E11De;
		bytes32 donId = bytes32("fun-polygon-amoy-1");
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
