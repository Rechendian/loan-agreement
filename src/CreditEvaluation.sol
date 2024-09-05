// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CreditEvaluation {
    mapping(address => uint) creditScores; //地址的信用分是多少

    address public oracle; //预言机地址

    // 预言机设置信用分
    modifier onlyOracle() {
        require(msg.sender == oracle);
        _;
    }

    constructor(address _oracle) {
        // 初始化预言机地址
        oracle = _oracle;
    }

    // set 信用分 只有预言机可以设置信用分
    function updateCreditScores(
        address _user,
        uint _creditScore
    ) public onlyOracle {
        creditScores[_user] = _creditScore;
    }

    // get 信用分
    function getCreditScore(address _user) public view returns (uint) {
        return creditScores[_user];
    }
}
