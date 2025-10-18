// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {DiamondFactory} from "../src/DiamondFactory.sol";
import {FactoryFacet} from "../src/facets/FactoryFacet.sol";
import {FacetCut, FacetCutAction} from "@diamond-storage/DiamondStorage.sol";
import {GetSelectors} from "@diamond-test/helpers/GetSelectors.sol";
import {Script} from "forge-std/Script.sol";

contract DiamondFactoryScript is Script, GetSelectors {
    address constant DIAMOND_CUT_FACET = 0xD1AC537fBE953b0868a6ec93F025c4bB05E6D1AC;
    address constant DIAMOND_LOUPE_FACET = 0xD1A1C850E1ACd4ce10941e40eD67de60db56D1A1;
    address constant OWNABLE_ROLES_FACET = 0x020e74BCB4b03d5Fd1D163d7948D67Ccb7718020;

    function run() public returns (address diamondFactory_) {
        vm.startBroadcast();
        FacetCut[] memory cuts = new FacetCut[](4);

        cuts[0] = FacetCut({
            facetAddress: DIAMOND_CUT_FACET,
            action: FacetCutAction.Add,
            functionSelectors: _getSelectors("DiamondCutFacet")
        });

        cuts[1] = FacetCut({
            facetAddress: DIAMOND_LOUPE_FACET,
            action: FacetCutAction.Add,
            functionSelectors: _getSelectors("DiamondLoupeFacet")
        });

        cuts[2] = FacetCut({
            facetAddress: OWNABLE_ROLES_FACET,
            action: FacetCutAction.Add,
            functionSelectors: _getSelectors("OwnableRolesFacet")
        });

        cuts[3] = FacetCut({
            facetAddress: address(new FactoryFacet{salt: vm.envBytes32("FACTORY_SALT")}()),
            action: FacetCutAction.Add,
            functionSelectors: _getSelectors("FactoryFacet")
        });

        diamondFactory_ = address(new DiamondFactory{salt: vm.envBytes32("DIAMOND_FACTORY_SALT")}(cuts, address(0), ""));
        vm.stopBroadcast();
    }
}
