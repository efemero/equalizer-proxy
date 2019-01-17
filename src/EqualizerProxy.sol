pragma solidity ^0.4.24;

import "ds-math/math.sol";

contract TubInterface {
  function open() public returns (bytes32);
  function join(uint) public;
  function exit(uint) public;
  function lock(bytes32, uint) public;
  function free(bytes32, uint) public;
  function draw(bytes32, uint) public;
  function wipe(bytes32, uint) public;
  function give(bytes32, address) public;
  function shut(bytes32) public;
  function bite(bytes32) public;
  function cups(bytes32) public returns (address, uint, uint, uint);
  function gem() public returns (TokenInterface);
  function gov() public returns (TokenInterface);
  function skr() public returns (TokenInterface);
  function sai() public returns (TokenInterface);
  function vox() public returns (VoxInterface);
  function ask(uint) public returns (uint);
  function mat() public returns (uint);
  function chi() public returns (uint);
  function ink(bytes32) public returns (uint);
  function tab(bytes32) public returns (uint);
  function rap(bytes32) public returns (uint);
  function per() public returns (uint);
  function pip() public returns (PipInterface);
  function pep() public returns (PepInterface);
  function tag() public returns (uint);
  function drip() public;
}

contract TapInterface {
  function skr() public returns (TokenInterface);
  function sai() public returns (TokenInterface);
  function tub() public returns (TubInterface);
  function bust(uint) public;
  function boom(uint) public;
  function cash(uint) public;
  function mock(uint) public;
  function heal() public;
}

contract TokenInterface {
  function allowance(address, address) public returns (uint);
  function balanceOf(address) public returns (uint);
  function approve(address, uint) public;
  function transfer(address, uint) public returns (bool);
  function transferFrom(address, address, uint) public returns (bool);
  function deposit() public payable;
  function withdraw(uint) public;
}

contract VoxInterface {
  function par() public returns (uint);
}

contract PipInterface {
  function read() public returns (bytes32);
}

contract PepInterface {
  function peek() public returns (bytes32, bool);
}

contract OtcInterface {
  function sellAllAmount(address, uint, address, uint) public returns (uint);
  function buyAllAmount(address, uint, address, uint) public returns (uint);
  function getPayAmount(address, address, uint) public constant returns (uint);
}

contract EqualizerProxy is DSMath {

  // this function can be used to draw an amount of DAI of the CDP, sell it for ETH on Oasis, and lock it back in the CDP
  function drawSellLock(TubInterface tub, OtcInterface otc, bytes32 cup, TokenInterface sai, uint drawAmt, TokenInterface weth, uint minLockAmt) public {
    // Borrow some SAI tokens
    tub.draw(cup, drawAmt);

    // Sell SAI tokens for WETH tokens
    if (sai.allowance(this, otc) < drawAmt) {
      sai.approve(otc, uint(-1));
    }
    uint buyAmt = otc.sellAllAmount(sai, drawAmt, weth, minLockAmt);
    require(buyAmt >= minLockAmt);

    // Convert WETH to PETH
    uint ink = rdiv(buyAmt, tub.per());
    if (tub.gem().allowance(this, tub) != uint(-1)) {
      tub.gem().approve(tub, uint(-1));
    }
    tub.join(ink);

    // LOCK PETH
    if (tub.skr().allowance(this, tub) != uint(-1)) {
      tub.skr().approve(tub, uint(-1));
    }
    tub.lock(cup, ink);
  }

  // this function can be used to free an amount of ETH from the CDP, sell it for DAI on Oasis, and wipe it back in the CDP
  function freeSellWipe(TubInterface tub, OtcInterface otc, bytes32 cup, TokenInterface sai, uint freeAmt, TokenInterface weth, uint minWipeAmt) public {
    if (freeAmt > 0) {
      // Free some PETH tokens
      uint ink = rdiv(freeAmt, tub.per());
      tub.free(cup, ink);
      if (tub.skr().allowance(this, tub) != uint(-1)) {
        tub.skr().approve(tub, uint(-1));
      }

      // Convert PETH to WETH
      tub.exit(ink);

      // Sell WETH tokens for SAI tokens
      if (weth.allowance(this, otc) < freeAmt) {
        weth.approve(otc, uint(-1));
      }
      uint wipeAmt = otc.sellAllAmount(weth, freeAmt, sai, minWipeAmt);
      require(wipeAmt >= minWipeAmt);

      // Wipe SAI
      wipe(tub, wipeAmt, cup);
    }
  }

  function wipe(TubInterface tub, uint wipeAmt, bytes32 cup) internal {
    if (tub.sai().allowance(this, tub) != uint(-1)) {
        tub.sai().approve(tub, uint(-1));
      }
      if (tub.gov().allowance(this, tub) != uint(-1)) {
        tub.gov().approve(tub, uint(-1));
      }
      bytes32 val;
      bool ok;
      (val, ok) = tub.pep().peek();
      require(ok);
      uint saiDebtFee = rmul(wipeAmt, rdiv(tub.rap(cup), tub.tab(cup)));
      uint govAmt = wdiv(saiDebtFee, uint(val));
      tub.gov().transferFrom(msg.sender, this, govAmt);
      tub.wipe(cup, wipeAmt);
  }
}

