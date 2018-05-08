pragma solidity ^0.4.21;

import "contracts/ownership/Owned.sol";
import "contracts/math/SafeMath.sol";

/**
* Contract Certificate is used by main contract to create new certificates (ideas).
* It has array of created certificates and certificate constructor.
* Contract owner can withdraw funds from contract.
*/
contract Certificate is Owned {

    using SafeMath for uint;

    struct certificateInfo {
        string certificateHash;
        string name;
        string description;
        string author;
        uint date;
        string certificateType;
    }

    certificateInfo[] public certificates;

    /**
     * Certificate constructor
     * @param _hash Unique certificate hash
     * @param _name Name of Certificate
     * @param _description Description
     * @param _author Author name
     * @param _certificateType One of predefined types
     * @param creator Addres to which you should transfer initial ownership (should be yours for default)
     * @constructor
     */
    function Certificate(
        string _hash,
        string _name,
        string _description,
        string _author,
        string _certificateType,
        address creator
    ) public Owned(creator) {

        certificateInfo memory newCertificate = certificateInfo({
            certificateHash: _hash,
            name: _name,
            description: _description,
            author: _author,
            date: now,
            certificateType: _certificateType
            });

        certificates.push(newCertificate);
    }

    /**
     * Withdraw ETH from this contract
     * @param  amount uint Amount to withdraw
     * @return bool
     */
    function withdraw(uint amount) onlyOwner public returns(bool) {
        require(amount <= address(this).balance);
        owner.transfer(amount);
        return true;
    }

    /**
     * Get balance of this contract
     * @return uint Balance
     */
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    /**
    * Fallback payable function
    */
    function () public payable {
    }

}
