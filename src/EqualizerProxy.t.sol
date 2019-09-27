pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./EqualizerProxy.sol";

contract EqualizerProxyTest is DSTest {
    EqualizerProxy proxy;

    function setUp() public {
        proxy = new EqualizerProxy();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
