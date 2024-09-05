// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Loan.sol";
import "./CreditEvaluation.sol";

contract Repayment {
    // 引入贷款合约，用于获取贷款信息
    Loan public loanContract;
    
    // 引入信用评估合约，用于更新用户的信用评分
    CreditEvaluation public creditEvaluation;

    // 构造函数，初始化贷款合约和信用评估合约的地址
    constructor(address _loanContract, address _creditEvaluation) {
        loanContract = Loan(_loanContract);
        creditEvaluation = CreditEvaluation(_creditEvaluation);
    }

    // 用户还款，传入的金额必须与贷款金额一致
    function repayLoan() public payable {
        // 获取用户的贷款请求信息
        Loan.LoanRequest memory request = loanContract.loanRequests(msg.sender);
        
        // 确保贷款已被批准
        require(request.approved, "Loan not approved");
        
        // 确保贷款尚未还清
        require(!request.repaid, "Loan already repaid");
        
        // 确保用户还款金额正确
        require(msg.value == request.amount, "Incorrect repayment amount");

        // 标记贷款已还清
        request.repaid = true;

        // 更新用户的信用评分（还款后，信用评分可能会提升）
        creditEvaluation.updateCreditScore(msg.sender, 10, 0); // 这里假设还款后链上数据增加 10 分
    }
}
