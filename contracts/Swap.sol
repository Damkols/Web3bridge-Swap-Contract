// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function withdrawEther() external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}


contract KolsSwap{

    IERC20 tokenA;
    IERC20 tokenB;

    struct LiquidityProvider{
        uint AmountA;
        uint AmountB;
    }
    
    uint public reserveA;
    uint public reserveB;
    // uint public totalReserve;

    // Specify the amount you want to allow the swap contract to spend
    uint256 allowanceAmount = 100000000000000000e18;


    mapping(address => LiquidityProvider) liquidityMap;

    constructor(address _tokenA, address _tokenB){
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 _amountA, uint256 _amountB) external {
        tokenA.transferFrom(msg.sender, address(this), _amountA);
        tokenB.transferFrom(msg.sender, address(this), _amountB);
        reserveA += _amountA;
        reserveB += _amountB;

        LiquidityProvider storage provider = liquidityMap[msg.sender];
        provider.AmountA += _amountA;
        provider.AmountB += _amountB;
    }

    
    function removeLiquidity(uint256 _amountA, uint256 _amountB) external {
        LiquidityProvider storage provider = liquidityMap[msg.sender];
        require(provider.AmountA >= 0, "You do not have enough Liquidity");
        require(provider.AmountB >= 0, "You do not have enough Liquidity");

        require(provider.AmountB >= _amountA, "You do not have enough Liquidity to withdraw");
        require(provider.AmountB >= _amountB, "You do not have enough Liquidity to withdraw");

        // Approve the swap contract to spend your tokens
        bool approvalSuccess = tokenA.approve(address(this), allowanceAmount);
        require(approvalSuccess, "Approval failed");
        // Approve the swap contract to spend your tokens
        bool approvalSuccess2 = tokenB.approve(address(this), allowanceAmount);
        require(approvalSuccess2, "Approval failed");

        tokenA.transferFrom(address(this), msg.sender, _amountA);
        tokenB.transferFrom(address(this), msg.sender, _amountB);
        reserveA -= _amountA;
        reserveB -= _amountB;

        provider.AmountA -= _amountA;
        provider.AmountB -= _amountB;
    }


    function swap(uint256 _amount) external {
        uint balance = tokenA.balanceOf(msg.sender);
        require(balance >= 0, "You do not have enough tokens to swap");

        // tokenA.approve(address(this), _amount);
        // tokenA.allowance(msg.sender, address(this));

        tokenA.transferFrom(msg.sender, address(this), _amount);
        reserveA += _amount;

        uint256 totalReserve = reserveA * reserveB;
        uint256 amount2 = (reserveB - (totalReserve/(reserveA - _amount)));

        tokenB.transfer(msg.sender, _amount);
        reserveB -= amount2;

    }

}