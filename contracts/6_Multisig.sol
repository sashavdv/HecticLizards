// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Multisig is Ownable {
    address private _primarySignatory;

    //TODO: add the signatory addresses here
    address private _signatory_2;
    address private _signatory_3;
    address private _signatory_4;
    address[] public _signatoryAddresses;

    uint256 private _signatureCount = 0;
    uint256 private _noRequiredSignatures = 1;

    mapping(address => bool) private signed;

    constructor(address _initAddress) {
        _primarySignatory = _initAddress;
        _signatoryAddresses.push(_initAddress);
    }

    function signTx() public {
        require(
            msg.sender == _primarySignatory ||
                msg.sender == _signatory_2 ||
                msg.sender == _signatory_3 ||
                msg.sender == _signatory_4,
            "ERROR: You are not a signatory"
        );
        require(!signed[msg.sender], "ERROR: You have already signed this tx");
        signed[msg.sender] = true;
        _signatureCount++;
    }

    function isSignedTx() internal view returns (bool) {
        return _signatureCount >= _noRequiredSignatures;
    }

    function changeSignatory2(address signatorAddress) public onlyOwner {
        _signatory_2 = signatorAddress;
    }

    function changeSignatory3(address signatorAddress) public onlyOwner {
        _signatory_3 = signatorAddress;
    }

    function changeSignatory4(address signatorAddress) public onlyOwner {
        _signatory_4 = signatorAddress;
    }

    function resetSig() internal {
        for (uint256 i = 0; i < _signatoryAddresses.length; i++) {
            signed[_signatoryAddresses[i]] = false;
        }

        _signatureCount = 0;
    }

    modifier onlySignatories() {
        bool verified = false;

        if (_primarySignatory == msg.sender) {
            verified = true;
        } else {
            for (uint256 i = 0; i < _signatoryAddresses.length; i++) {
                if (_signatoryAddresses[i] == msg.sender) {
                    verified = true;
                    break;
                }
            }
        }

        require(verified, "Ownable: caller is not a signatory");
        _;
    }
}
