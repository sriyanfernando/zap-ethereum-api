pragma solidity ^0.4.24;

import "../../lib/ownership/Ownable.sol";
import "../../lib/ownership/Upgradable.sol";


contract ZapCoordinator is Ownable {

	mapping(string => address) contracts; 
	string[] loadedContracts;

	// used for modifying an existing contract
	function updateContract(string contractName, address newAddress) external onlyOwner {
		if(contracts[contractName] == 0){
			// first time adding this contract
			loadedContracts.push(contractName);
		}
		contracts[contractName] = newAddress;
	}

	function getContractName(uint index) public view returns (string){
		return loadedContracts[index];
	}

	function getContract(string contractName) public view returns (address){
		return contracts[contractName];
	}

	function updateAllDependencies() external onlyOwner{
		for(uint i=0; i<loadedContracts.length; i++){
			address c = contracts[loadedContracts[i]];
			Upgradable(c).updateDependencies();
		}
	}

}