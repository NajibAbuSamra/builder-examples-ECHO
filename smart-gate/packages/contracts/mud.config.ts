import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "test",
  tables: {
    GateAccess: {
      schema: {
        smartObjectId: "uint256",
        corp: "uint256"
      },
      key: ["smartObjectId"],
    },
	  AllowedCorpWhiteList: {
	    schema: {
        corp: "uint256",
        allowed: "bool",
	    },
	    key: ["corp"],
	  },
    GateAccessWhitelist: {
      schema: {
        smartObjectId: "uint256",
        corp: "uint256[]"
      },
      key: ["smartObjectId"],
    },
  },
});