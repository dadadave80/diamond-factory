// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {DiamondFactoryScript} from "../script/DiamondFactory.s.sol";
import {DiamondFactory} from "../src/DiamondFactory.sol";
import {IFactory} from "../src/interfaces/IFactory.sol";
import {DiamondCutFacet} from "@diamond/facets/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "@diamond/facets/DiamondLoupeFacet.sol";
import {OwnableRolesFacet} from "@diamond/facets/OwnableRolesFacet.sol";
import {DiamondInit} from "@diamond/initializers/DiamondInit.sol";
import {Test} from "forge-std/Test.sol";

contract DiamondFactoryTest is Test {
    address constant DIAMOND_CUT_FACET = 0xD1AC537fBE953b0868a6ec93F025c4bB05E6D1AC;
    address constant DIAMOND_LOUPE_FACET = 0xD1A1C850E1ACd4ce10941e40eD67de60db56D1A1;
    address constant OWNABLE_ROLES_FACET = 0x020e74BCB4b03d5Fd1D163d7948D67Ccb7718020;
    address private constant DIAMOND_INIT = address(DiamondInit(0xD1Ab4C0546Aaa0Bd9b0Fd73fEBa54D4Ca3038D1A));

    address public diamondFactory;
    IFactory public factory;
    DiamondCutFacet public diamondCutFacet;
    DiamondLoupeFacet public diamondLoupeFacet;
    OwnableRolesFacet public ownableRolesFacet;

    function setUp() public {
        vm.etch(DIAMOND_CUT_FACET, address(new DiamondCutFacet()).code);
        vm.etch(DIAMOND_LOUPE_FACET, address(new DiamondLoupeFacet()).code);
        vm.etch(OWNABLE_ROLES_FACET, address(new OwnableRolesFacet()).code);
        vm.etch(DIAMOND_INIT, address(new DiamondInit()).code);

        diamondFactory = new DiamondFactoryScript().run();
        factory = IFactory(diamondFactory);
        diamondCutFacet = DiamondCutFacet(diamondFactory);
        diamondLoupeFacet = DiamondLoupeFacet(diamondFactory);
        ownableRolesFacet = OwnableRolesFacet(diamondFactory);
    }

    function testCreate() public {
        address owner = makeAddr("owner");
        address clone = factory.create(owner);
        ownableRolesFacet = OwnableRolesFacet(clone);
        assertEq(ownableRolesFacet.owner(), owner);
    }

    function test_RevertCreate() public {
        address owner = makeAddr("owner");
        address clone = factory.create(owner);
        ownableRolesFacet = OwnableRolesFacet(clone);
        assertEq(ownableRolesFacet.owner(), owner);
        vm.expectRevert();
        DiamondFactory(payable(clone)).initialize(address(this), owner);
    }
}
