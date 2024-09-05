// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreditEvaluation.sol";

contract Loan {
    // 定义一个结构体来表示贷款请求
    struct LoanRequest {
        uint256 amount;          // 用户请求的贷款金额
        uint256 term;            // 贷款期限（以天为单位）
        uint256 interestRate;    // 根据信用评分计算出的贷款利率
        bool approved;           // 标记贷款请求是否被批准
        bool repaid;             // 标记贷款是否已还清
    }

    // 存储每个用户的贷款请求，地址对应的贷款请求信息
    mapping(address => LoanRequest) public loanRequests;
    
    // 引入信用评估合约，用于获取用户的信用评分
    CreditEvaluation public creditEvaluation;

    // 构造函数，初始化信用评估合约的地址
    constructor(address _creditEvaluation) {
        creditEvaluation = CreditEvaluation(_creditEvaluation);
    }

    // 用户请求贷款，传入贷款金额和期限
    function requestLoan(uint256 amount, uint256 term) public {
        // 获取用户的信用评分
        uint256 creditScore = creditEvaluation.getCreditScore(msg.sender);
        
        // 计算该用户允许借贷的最大金额
        uint256 maxLoanAmount = calculateMaxLoanAmount(creditScore);
        
        // 确保请求的金额不超过最大允许金额
        require(amount <= maxLoanAmount, "Requested amount exceeds allowed limit");

        // 计算贷款利率
        uint256 interestRate = calculateInterestRate(creditScore, amount, term);
        
        // 基于信用评分审批贷款请求
        bool approved = approveLoan(creditScore, amount);

        // 存储贷款请求的信息
        loanRequests[msg.sender] = LoanRequest({
            amount: amount,
            term: term,
            interestRate: interestRate,
            approved: approved,
            repaid: false
        });
    }

    // 计算用户允许借贷的最大金额，基于信用评分
    function calculateMaxLoanAmount(uint256 creditScore) internal pure returns (uint256) {
        // 简单模型：信用评分越高，允许借贷的金额越大
        return creditScore * 10;
    }

    // 计算贷款利率，基于信用评分、贷款金额和期限
    function calculateInterestRate(uint256 creditScore, uint256 amount, uint256 term) internal pure returns (uint256) {
        // 简单模型：信用评分越高，利率越低
        return (1000 - creditScore) / 10;
    }

    // 审批贷款请求，基于信用评分和贷款金额
    function approveLoan(uint256 creditScore, uint256 amount) internal pure returns (bool) {
        // 简单逻辑：信用评分超过 500 分，且请求金额不超过信用评分的 10 倍
        return creditScore > 500 && amount < creditScore * 10;
    }
}
