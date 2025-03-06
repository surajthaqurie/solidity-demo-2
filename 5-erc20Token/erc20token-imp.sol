// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

/* https://ethereum.org/en/developers/docs/standards/tokens/erc-20/ */
abstract contract ERC20_Interface{
    // functions
    function name() public view virtual  returns (string memory);
    function symbol() public view virtual  returns (string memory);
    function decimals() public view virtual  returns (uint8);
    function totalSupply() public view virtual  returns (uint256);
    function balanceOf(address _owner) public view virtual  returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual  returns (bool success);
    function approve(address _spender, uint256 _value) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual view returns (uint256 remaining);

    // events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract TNT is ERC20_Interface {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;

    mapping (address => uint) public balances; 
    mapping (address => mapping (address => uint)) public allowances;

    constructor (){
        _name = "TntToken";
        _symbol = "TNT";
        _decimals = 18;
        _totalSupply = 10000 * 10 **_decimals;
      
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender ,_totalSupply);
    }


    function name() public view override returns (string memory){
        return  _name;
     }

    function symbol() public view override   returns (string memory){
        return  _symbol;
    }

    function decimals() public view override   returns (uint8){
        return  _decimals;
    }

    function totalSupply() public view override   returns (uint256){
        return  _totalSupply;
    }

    function balanceOf(address _owner) public view override   returns (uint256 balance){
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override  returns (bool success){
        allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public override  view returns (uint256 remaining){
        return allowances[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) public override   returns (bool success){
        require(balanceOf(_from) >= _value, "Not enough balance!");

        balances[_from] -= _value;
        balances[_to] +=_value;
    
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override  returns (bool success){
        transferFrom(msg.sender, _to, _value);
        return true;
    }
}

/* Deployment and Test
    - Environment (Injected web3)
    - MetaMask Permission (Confirm)
    - Import token in Metamask (Smart contract address)
    - Than transaction through MetaMask (one account to another)
*/