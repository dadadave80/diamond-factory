// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {LibDiamond} from "@diamond/libraries/LibDiamond.sol";
import {IFactory} from "../interfaces/IFactory.sol";
import {IInitializer} from "../interfaces/IInitializer.sol";

library LibFactory {
    using Clones for address;

    function _clone(address _owner) internal returns (address diamond_) {
        diamond_ = address(this).clone();
        IInitializer(diamond_).initialize(_owner);
    }
}
