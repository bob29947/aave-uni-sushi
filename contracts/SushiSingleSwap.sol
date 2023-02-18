// SPDX-License-Identifier: MIT
pragma solidity =0.6.12;

import "@sushiswap/sushiswap/contracts/interfaces/IUniswapV2Router02.sol";
import "@sushiswap/sushiswap/contracts/libraries/TransferHelper.sol";
import {IERC20Uniswap} from "@sushiswap/sushiswap/contracts/interfaces/IERC20.sol";

contract SushiSingleSwap {
    IUniswapV2Router02 public immutable uniswapV2Router02;

    constructor(address _routerAddress) public {
        uniswapV2Router02 = IUniswapV2Router02(_routerAddress);
    }

    function depositToken(uint256 _amountIn, address _tokenIn) external {
        TransferHelper.safeTransferFrom(_tokenIn, msg.sender, address(this), _amountIn);
    }

    function withdraw(address _tokenAddress) external {
        IERC20Uniswap(_tokenAddress).transfer(
            msg.sender,
            IERC20Uniswap(_tokenAddress).balanceOf(address(this))
        );
    }

    function swapToken(
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _tokenIn,
        address _tokenOut
    ) external {
        TransferHelper.safeApprove(_tokenIn, address(uniswapV2Router02), _amountIn);
        address[] memory path;
        path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        uniswapV2Router02.swapExactTokensForTokens(
            _amountIn,
            _amountOutMin,
            path,
            address(this),
            block.timestamp
        );
    }
}
