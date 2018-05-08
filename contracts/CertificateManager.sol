pragma solidity ^0.4.21;

import "contracts/math/SafeMath.sol";
import "contracts/ownership/Managed.sol";
import "contracts/certificate/Certificate.sol";

contract CertificateManager is Managed {
    using SafeMath for uint;

    event Invested(address indexed beneficiary, uint256 weiAmount);

    struct newCertificateData {
        address _address;
        uint _invested;
    }

    newCertificateData[] public deployedCertificates;

    /**
    * @dev Contract constructor
    * @param _manager Not required, will be the same as owner if not added
    */
    function CertificateManager(address _manager) public Managed(_manager){}

    /**
    * @dev New certificate creator, also adds newCertificate address into array newCertificateData
    * @param _hash Generated has of certificate from Customer
    * @param _name Name of Certificate from Customer
    * @param _description Description of Certificate from Customer
    * @param _author Author of Certificate from Customer
    * @param _certificateType Certificate Types from Customer, should be stored with "." as separator
    */
    function createCertificate (
        string _hash,
        string _name,
        string _description,
        string _author,
        string _certificateType)
        public onlyManager {
            address newCertificate = new Certificate(_hash, _name, _description, _author, _certificateType, msg.sender);
            newCertificateData memory certificateInfo = newCertificateData({
                _address: newCertificate,
                _invested: 0
        });
        deployedCertificates.push(certificateInfo);
    }

    /**
     * Payable function
     */
    function deposit() public payable {}

    /**
     * Invest money from this manager to certificate
     * @param id uint
     * @param value uint
     */
    function investEth(uint _id, uint _value) public onlyOwner {
        assert(_value > 0 && address(this).balance > 0);
        deployedCertificates[_id]._invested = deployedCertificates[_id]._invested + _value;
        deployedCertificates[_id]._address.transfer(_value);
        emit Invested(deployedCertificates[_id]._address, _value);
    }

    /**
     *  WithdrawEth
     * @param  _beneficiary address to withdraw
     * @param  _amount uint256 Amount of money
     */
     function withdrawEth(address _beneficiary, uint256 _amount) onlyOwner public {
         assert(_beneficiary != address(0) && address(this).balance >= _amount);
         _beneficiary.transfer(_amount);
     }

    /**
     * Get balance in ether/wei
     */
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}
