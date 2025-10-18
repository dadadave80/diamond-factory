// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {DiamondFactory} from "../DiamondFactory.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

library LibFactory {
    using Clones for address;

    function _create(address _owner) internal returns (address diamond_) {
        diamond_ = address(this).clone();
        DiamondFactory(payable(diamond_)).initialize(address(this), _owner);
    }
}
