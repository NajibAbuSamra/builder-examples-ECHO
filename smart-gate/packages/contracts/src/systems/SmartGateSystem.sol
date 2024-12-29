// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { console } from "forge-std/console.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { CharactersTable } from "@eveworld/world/src/codegen/tables/CharactersTable.sol";
import { GateAccess } from "../codegen/tables/GateAccess.sol";
import { AllowedCorpWhiteList } from "../codegen/tables/AllowedCorpWhiteList.sol";
import { GateAccessWhitelist } from "../codegen/tables/GateAccessWhitelist.sol";

/**
 * @dev This contract is an example for implementing logic to a smart gate
 */
contract SmartGateSystem is System {
  function canJump(uint256 characterId, uint256 sourceGateId, uint256 destinationGateId/*, bool gateWhitelist*/) public view returns (bool) {
    //Get the allowed corp
    console.log("-------------------\nReading from GateAccessWhitelist");
    uint256[] memory allowedCorp = GateAccessWhitelist.get(sourceGateId);

    //Get the character corp
    uint256 characterCorp = CharactersTable.getCorpId(characterId);
    
    //if(gateWhitelist){
    for (uint256 i = 0; i < allowedCorp.length; i++) {
      if(allowedCorp[i] == characterCorp){
        console.log("-------------------\nCan jump, corp in Allowed Whitelist:");
        return true;
      }
    }
    console.log("-------------------\nCan't jump, corp not allowed by Allowed Whitelist:");
    return false;
    // }
    // else{
    //   if(AllowedCorpWhiteList.get(characterCorp) == true){
    //     console.log("-------------------\nCan jump, corp in Allowed Whitelist: Character - ", AllowedCorpWhiteList.get(characterCorp) ," GateCirp: - ", AllowedCorpWhiteList.get(allowedCorp));
    //     return true;
    //   }
    // }

    // //If the corp is the same, allow jumps
    // if(AllowedCorpWhiteList.get(characterCorp) == true){
    //   console.log("-------------------\nCan jump, corp in Allowed Whitelist: Character - ", AllowedCorpWhiteList.get(characterCorp) ," GateCirp: - ", AllowedCorpWhiteList.get(allowedCorp));
    //   return true;
    // } else{
    //   console.log("-------------------\nCan't jump, corp not allowed by Allowed Whitelist:", characterCorp);

    //   if(allowedCorp == characterCorp){
    //     return true;
    //   }

    //   return false;
    // }    
  }

  function setAllowedCorp(uint256 sourceGateId, uint256[] memory corpID) public {
    GateAccessWhitelist.set(sourceGateId, corpID);
  }

  function setCorpWhiteList(uint256 corpID) public {
    AllowedCorpWhiteList.set(corpID, true);
  }
}