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
import { GateAccessWhitelist } from "../codegen/tables/GateAccessWhitelist.sol";

import { IERC721 } from "@eveworld/world/src/modules/eve-erc721-puppet/IERC721.sol";

import { DeployableTokenTable } from "@eveworld/world/src/codegen/tables/DeployableTokenTable.sol";

/**
 * @dev This contract is an example for implementing logic to a smart gate
 * @notice The additional commented out parameter in the funtion call is unimplemented flag to use a whitelist or not
 */

contract SmartGateSystem is System {  
  /**
   * @dev Only owner modifer
   */
  modifier onlyOwner(uint256 smartObjectId) {
    address ssuOwner = IERC721(DeployableTokenTable.getErc721Address()).ownerOf(smartObjectId);
    require(_msgSender() == ssuOwner, "Only owner can call this function");
    _;
  }

  function canJump(uint256 characterId, uint256 sourceGateId, uint256 destinationGateId) public view returns (bool) {
    //Get the allowed corp
    uint256[] memory allowedCorp = GateAccessWhitelist.get(sourceGateId);

    //Get the character corp
    uint256 characterCorp = CharactersTable.getCorpId(characterId);
    //if(gateWhitelist){
    for (uint256 i = 0; i < allowedCorp.length; i++) {
      if(allowedCorp[i] == characterCorp){
        console.log("-------------------\nCan jump, corp in Allowed Whitelist: ", characterCorp);
        return true;
      }
    }
    console.log("-------------------\nCan't jump, corp not allowed by Allowed Whitelist: ", characterCorp);
    return false;
  }

  function setAllowedCorp(uint256 sourceGateId, uint256[] memory corpID) public onlyOwner(sourceGateId) {
    GateAccessWhitelist.set(sourceGateId, corpID);
  }
}