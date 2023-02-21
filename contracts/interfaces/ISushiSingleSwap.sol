// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

interface ISushiSingleSwap {
    function depositToken(uint256 amountIn, address tokenIn) external;

    function withdraw(address tokenAddress) external;

    function swapToken(
        uint256 amountIn,
        uint256 amountOutMinimum,
        address tokenIn,
        address tokenOut
    ) external;
}
