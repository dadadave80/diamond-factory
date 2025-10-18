// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {FacetCut, FacetCutAction} from "@diamond-storage/DiamondStorage.sol";
import {IDiamondLoupe} from "@diamond/interfaces/IDiamondLoupe.sol";
import {LibDiamond} from "@diamond/libraries/LibDiamond.sol";

library LibInitializer {
    address constant DIAMOND_CUT_FACET = 0xD1AC537fBE953b0868a6ec93F025c4bB05E6D1AC;
    address constant DIAMOND_LOUPE_FACET = 0xD1A1C850E1ACd4ce10941e40eD67de60db56D1A1;
    address constant OWNABLE_ROLES_FACET = 0x020e74BCB4b03d5Fd1D163d7948D67Ccb7718020;
    address private constant DIAMOND_INIT = 0xD1Ab4C0546Aaa0Bd9b0Fd73fEBa54D4Ca3038D1A;

    function _initialize(address _diamond, address _owner) internal {
        FacetCut[] memory cuts = new FacetCut[](3);
        cuts[0] = FacetCut({
            facetAddress: DIAMOND_CUT_FACET,
            action: FacetCutAction.Add,
            functionSelectors: IDiamondLoupe(_diamond).facetFunctionSelectors(DIAMOND_CUT_FACET)
        });
        cuts[1] = FacetCut({
            facetAddress: DIAMOND_LOUPE_FACET,
            action: FacetCutAction.Add,
            functionSelectors: IDiamondLoupe(_diamond).facetFunctionSelectors(DIAMOND_LOUPE_FACET)
        });
        cuts[2] = FacetCut({
            facetAddress: OWNABLE_ROLES_FACET,
            action: FacetCutAction.Add,
            functionSelectors: IDiamondLoupe(_diamond).facetFunctionSelectors(OWNABLE_ROLES_FACET)
        });
        LibDiamond._diamondCut(cuts, DIAMOND_INIT, abi.encodeWithSignature("initDiamond(address)", _owner));
    }
}
