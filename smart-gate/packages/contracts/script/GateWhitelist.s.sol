// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/tables/ResourceIds.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { Utils } from "../src/systems/Utils.sol";
import { SmartGateLib } from "@eveworld/world/src/modules/smart-gate/SmartGateLib.sol";
import { FRONTIER_WORLD_DEPLOYMENT_NAMESPACE } from "@eveworld/common-constants/src/constants.sol";
import { Utils as SmartGateUtils } from "@eveworld/world/src/modules/smart-character/Utils.sol";
import { GateAccessWhitelist } from "../src/codegen/tables/GateAccessWhitelist.sol";

contract GateWhitelist is Script {
  using SmartGateUtils for bytes14;
  using SmartGateLib for SmartGateLib.World;

  SmartGateLib.World smartGate;

  function run(address worldAddress) external {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 privateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(privateKey);

    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);

    smartGate = SmartGateLib.World({ iface: IBaseWorld(worldAddress), namespace: FRONTIER_WORLD_DEPLOYMENT_NAMESPACE });

    uint256 smartGateId = vm.envUint("SOURCE_GATE_ID");

    ResourceId systemId = Utils.smartGateSystemId();

    //This function can only be called by the owner of the smart turret
    smartGate.configureSmartGate(smartGateId, systemId);

    //Get the allowed corp
    // uint256 size = vm.envUint("NUM_OF_ALLOWED_CORPS");
    // console.log("-------------------\nNUM_OF_ALLOWED_CORPS ", size);
    // uint256[] memory corpIDs = new uint256[](size);
    // for (uint256 i = 0; i < size; i++) {
    //   string memory corpIDString = string.concat("ALLOWED_CORP_ID_", Strings.toString(i));
    //   uint256 corpID = vm.envUint(corpIDString);
    //   console.log("-------------------\nCorpName: ", corpIDString, " CorpID: ", corpID);
    //   corpIDs[i] = corpID;
    // }
    uint256[] memory corpIDs = vm.envUint("WHITELIST_CORP_IDS",",");
    //Set the MUD table for the corp whitelist
    GateAccessWhitelist.set(smartGateId, corpIDs);

    vm.stopBroadcast();
  }
}
