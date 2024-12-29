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
import { AllowedCorpWhiteList } from "../src/codegen/tables/AllowedCorpWhiteList.sol";

contract WhiteListCorp is Script {
  using SmartGateUtils for bytes14;
  using SmartGateLib for SmartGateLib.World;

  SmartGateLib.World smartGate;

  function run(address worldAddress) external {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 privateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(privateKey);

    StoreSwitch.setStoreAddress(worldAddress);
    IBaseWorld world = IBaseWorld(worldAddress);
    //Get the allowed corp
    uint256 corpID = vm.envUint("WHITELIST_CORP_ID");

    //Set the MUD table for the corp whitelist
    AllowedCorpWhiteList.set(corpID, true);

    uint256 ownerCorpID = vm.envUint("ALLOWED_CORP_ID");
    AllowedCorpWhiteList.set(ownerCorpID, true);

    vm.stopBroadcast();
  }
}
