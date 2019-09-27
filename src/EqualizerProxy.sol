pragma solidity ^0.5.10;

import "ds-math/math.sol";

contract TubInterface {
  function open() public returns (bytes32);
  function join(uint256) public;
  function exit(uint256) public;
  function lock(bytes32, uint256) public;
  function free(bytes32, uint256) public;
  function draw(bytes32, uint256) public;
  function wipe(bytes32, uint256) public;
  function give(bytes32, address) public;
  function shut(bytes32) public;
  function bite(bytes32) public;
  function cups(bytes32) public returns (address, uint256, uint256, uint256);
  function gem() public returns (TokenInterface);
  function gov() public returns (TokenInterface);
  function skr() public returns (TokenInterface);
  function sai() public returns (TokenInterface);
  function vox() public returns (VoxInterface);
  function ask(uint256) public returns (uint256);
  function mat() public returns (uint256);
  function chi() public returns (uint256);
  function ink(bytes32) public returns (uint256);
  function tab(bytes32) public returns (uint256);
  function rap(bytes32) public returns (uint256);
  function per() public returns (uint256);
  function pip() public returns (PipInterface);
  function pep() public returns (PepInterface);
  function tag() public returns (uint256);
  function drip() public;
}

contract TapInterface {
  function skr() public returns (TokenInterface);
  function sai() public returns (TokenInterface);
  function tub() public returns (TubInterface);
  function bust(uint256) public;
  function boom(uint256) public;
  function cash(uint256) public;
  function mock(uint256) public;
  function heal() public;
}

contract TokenInterface {
  function allowance(address, address) public returns (uint256);
  function balanceOf(address) public returns (uint256);
  function approve(address, uint256) public;
  function transfer(address, uint256) public returns (bool);
  function transferFrom(address, address, uint256) public returns (bool);
  function deposit() public payable;
  function withdraw(uint256) public;
}

contract VoxInterface {
  function par() public returns (uint256);
}

contract PipInterface {
  function read() public returns (bytes32);
}

contract PepInterface {
  function peek() public returns (bytes32, bool);
}

contract OtcInterface {
  function sellAllAmount(address pay_gem, uint256 pay_amt, address buy_gem, uint256 min_fill_amount) public returns (uint256 token_bought);
  function buyAllAmount(address buy_gem, uint256 buy_amt, address pay_gem, uint256 max_fill_amount) public returns (uint256);
  function getPayAmount(address pay_gem, address buy_gem, uint256 buy_amt) public view returns (uint256);
  function getBuyAmount(address buy_gem, address pay_gem, uint256 pay_amt) public view returns (uint256);
}

// Solidity Interface
contract UniswapExchangeInterface {
  // Address of ERC20 token sold on this exchange
  function tokenAddress() external view returns (address token);
  // Address of Uniswap Factory
  function factoryAddress() external view returns (address factory);
  // Provide Liquidity
  function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
  function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
  // Get Prices
  function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
  function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
  function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
  function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
  // Trade ETH to ERC20
  function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
  function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
  function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
  function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
  // Trade ERC20 to ETH
  function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
  function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
  function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
  function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
  // Trade ERC20 to ERC20
  function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
  function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
  function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
  function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
  // Trade ERC20 to Custom Pool
  function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
  function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
  function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
  function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
  // ERC20 comaptibility for liquidity tokens
  bytes32 public name;
  bytes32 public symbol;
  uint256 public decimals;
  function transfer(address _to, uint256 _value) external returns (bool);
  function transferFrom(address _from, address _to, uint256 value) external returns (bool);
  function approve(address _spender, uint256 _value) external returns (bool);
  function allowance(address _owner, address _spender) external view returns (uint256);
  function balanceOf(address _owner) external view returns (uint256);
  function totalSupply() external view returns (uint256);
  // Never use
  function setup(address token_addr) external;
}

contract EqualizerProxy is DSMath {

  // This function is used when ETH price is up. It draws some DAI, sells them for ETH on oasis or uniswap (at best price), and then locks back the ETH in the CDP.
  function boost(
    uint256 boostDaiAmt,
    uint256 minEthAmt,
    TubInterface tub,
    OtcInterface otc,
    UniswapExchangeInterface uniswapDai,
    bytes32 cup,
    TokenInterface sai,
    TokenInterface weth,
    uint256 deadline
  ) public {
    // deadline security
    require(block.timestamp < deadline);

    // Borrow DAI
    tub.draw(cup, boostDaiAmt);

    // Compare prices for ETH/DAI
    uint256 oasisEth = otc.getBuyAmount(address(weth), address(sai), boostDaiAmt);
    uint256 uniswapEth = uniswapDai.getTokenToEthInputPrice(boostDaiAmt);
    uint256 ethAmt = 0;

    if (uniswapEth > oasisEth) {
      // Sell DAI for ETH on uniswap, then wrap to WETH
      require(address(sai) == uniswapDai.tokenAddress());
      if (sai.allowance(address(this), address(uniswapDai)) < boostDaiAmt) {
        sai.approve(address(uniswapDai), uint256(-1));
      }
      ethAmt = uniswapDai.tokenToEthSwapInput(boostDaiAmt, minEthAmt, deadline);
      if (tub.gem().allowance(address(this), address(uniswapDai)) < ethAmt) {
        tub.gem().approve(address(uniswapDai), uint256(-1));
      }
      tub.gem().deposit.value(ethAmt)();
    } else {
      // Sell DAI for WETH on oasis
      if (sai.allowance(address(this), address(otc)) < boostDaiAmt) {
        sai.approve(address(otc), uint256(-1));
      }
      ethAmt = otc.sellAllAmount(address(sai), boostDaiAmt, address(weth), minEthAmt);
    } 

    // Convert WETH to PETH
    uint256 ink = rdiv(ethAmt, tub.per());
    if (tub.gem().allowance(address(this), address(tub)) != uint256(-1)) {
      tub.gem().approve(address(tub), uint256(-1));
    }
    tub.join(ink);

    // Lock PETH
    if (tub.skr().allowance(address(this), address(tub)) != uint256(-1)) {
      tub.skr().approve(address(tub), uint256(-1));
    }
    tub.lock(cup, ink);

  }

  // This function is used when ETH price drops. It free som ETH, sells them for DAI and MKR (for the fee), and then wipe the DAI from the CDP.
  function repay(
    uint256 freeEthAmt,
    uint256 minDaiAmt,
    TubInterface tub,
    OtcInterface otc,
    UniswapExchangeInterface uniswapDai,
    UniswapExchangeInterface uniswapMkr,
    bytes32 cup,
    TokenInterface sai,
    TokenInterface weth,
    TokenInterface mkr,
    uint256 deadline
  ) public {
    // deadline security
    require(block.timestamp < deadline);
    if (sai.allowance(address(this), address(uniswapDai)) < minDaiAmt) {
      sai.approve(address(uniswapDai), uint256(-1));
    }
    if (weth.allowance(address(this), address(otc)) < freeEthAmt) {
      weth.approve(address(otc), uint256(-1));
    }
    if (sai.allowance(address(this), address(otc)) < minDaiAmt) {
      sai.approve(address(otc), uint256(-1));
    }

    uint256 daiAmt = buyBestDaiOffer(freeEthAmt, sai, weth, otc, uniswapDai, tub, cup, deadline);
    require(daiAmt >= minDaiAmt);

    // Find MKR amount for the fees
    uint256 mkrFee =  calculateFee(daiAmt, tub, cup);

    // Find best MKR price
    uint256 feeEthAmt = uniswapMkr.getEthToTokenOutputPrice(mkrFee);

    // Uwrap and sell ETH for MKR on uniswap
    tub.gem().withdraw(feeEthAmt);
    if (mkr.allowance(address(this), address(uniswapMkr)) < mkrFee) {
      mkr.approve(address(uniswapMkr), uint256(-1));
    }
    uint256 boughtMkr = uniswapMkr.ethToTokenSwapInput.value(feeEthAmt)(mkrFee, deadline);
    require(boughtMkr == mkrFee);

    // Repay DAI
    wipe(tub, daiAmt, cup);
  }

  function buyBestDaiOffer(
    uint256 freeEthAmt,
    TokenInterface sai,
    TokenInterface weth,
    OtcInterface otc,
    UniswapExchangeInterface uniswapDai,
    TubInterface tub,
    bytes32 cup,
    uint256 deadline
  ) internal returns (uint256) {
    // Find best DAI price and find DAI amount to repay
    uint256 oasisDaiExpected = otc.getBuyAmount(address(sai), address(weth), freeEthAmt);
    uint256 uniswapDaiExpected = uniswapDai.getEthToTokenInputPrice(freeEthAmt);
    uint256 daiAmt = 0;

    freeWeth(freeEthAmt, tub, cup);
    // Compare prices for ETH/DAI
    if (uniswapDaiExpected > oasisDaiExpected){
      // Unwrap and sell ETH for DAI on uniswap
      tub.gem().withdraw(freeEthAmt);
      daiAmt = uniswapDai.ethToTokenSwapInput.value(freeEthAmt)(0, deadline);
    } else {
      // Sell WETH for DAI on oasis
      daiAmt = otc.sellAllAmount(address(weth), freeEthAmt, address(sai), 0);
    }
    return daiAmt;
  }

  function calculateFee(uint256 daiAmt, TubInterface tub, bytes32 cup) internal returns (uint256){
    uint256 daiFee = rmul(daiAmt, rdiv(tub.rap(cup), tub.tab(cup)));
    bytes32 mkrPrice; 
    bool ok;
    (mkrPrice, ok) = tub.pep().peek();
    require(ok);
    uint256 mkrFee = wdiv(daiFee, uint(mkrPrice));
    return mkrFee;
  }


  function freeWeth(uint256 ethAmt, TubInterface tub, bytes32 cup) internal {
    // Free (ETH for DAI) + (ETH for MKR) -> PETH
    uint256 pethAmt = rdiv(ethAmt, tub.per());
    tub.free(cup, pethAmt);

    // Convert PETH to WETH
    if (tub.skr().allowance(address(this), address(tub)) != uint256(-1)) {
      tub.skr().approve(address(tub), uint256(-1));
    }
    tub.exit(pethAmt);
  }

  function wipe(TubInterface tub, uint256 wipeAmt, bytes32 cup) internal {
    if (tub.sai().allowance(address(this), address(tub)) != uint256(-1)) {
      tub.sai().approve(address(tub), uint256(-1));
    }
    if (tub.gov().allowance(address(this), address(tub)) != uint256(-1)) {
      tub.gov().approve(address(tub), uint256(-1));
    }
    bytes32 val;
    bool ok;
    (val, ok) = tub.pep().peek();
    require(ok);
    uint256 saiDebtFee = rmul(wipeAmt, rdiv(tub.rap(cup), tub.tab(cup)));
    uint256 govAmt = wdiv(saiDebtFee, uint256(val));
    tub.gov().transferFrom(msg.sender, address(this), govAmt);
    tub.wipe(cup, wipeAmt);
  }
}

