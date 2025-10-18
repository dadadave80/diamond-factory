// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {IFactory} from "../interfaces/IFactory.sol";
import {LibFactory} from "../libs/LibFactory.sol";

contract FactoryFacet is IFactory {
    using LibFactory for *;

    function create(address _owner) external returns (address) {
        return _owner._create();
    }
}
