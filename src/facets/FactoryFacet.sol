// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {LibFactory} from "../libs/LibFactory.sol";
import {IFactory} from "../interfaces/IFactory.sol";

contract FactoryFacet is IFactory {
    using LibFactory for *;

    function clone(address _owner) external returns (address) {
        return _owner._clone();
    }
}
