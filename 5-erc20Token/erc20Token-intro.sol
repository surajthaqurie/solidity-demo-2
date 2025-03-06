// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;


/* 2015 - https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
    - They are digital assets IN EXISTING BLOCKCHAIN
    - They are used make digital currency
    - loyalty points
    - They can be represented as ownership shared in a company
    - They run on Ethereum blockchain (eg: shiba inu coin, mata - decentralized lang game (as game reward)
    
    - No need to create the own blockchain
    - This become cheaper (fixing bugs, maintenance)
    - 
    - ERC 20 - Ethereum request for comment || 20- serial number
    - ERC 721 - NFT (non fungible tokens) 
    - ERC create setup of rule (standards) for the developer and make the guidelines for writing code

    ** Following these standard make life easier for blockchain developers and it can be more compatible with exchange and DAPPS **

    - Stable coins - $1 value is to some currency (ether)
    - For any kind of transaction of ERC token we have to pay gas (gas is depending as load)
    - ERC token has 6 obligate rules and 3 optional rules
    #6 obligate:
        - total supply (toke)
        - Balance of (contract)
        - Transfer (address, amount)
        - TransferFrom (from,to, amount)
        - Only Approved person uses transferFrom
        - Allowance
    #3 optional
        - Name (coin)
        - Symbol (3 words)
        - Decimals (100paisa - 10power2, 2 is decimals )


    Deployment
    - Pool (Liquidity Pool: uniswap | pancake swap)
    - Define the value then can be purchasable like cryptocurrency

    Drawbacks ERC20:
    - Very high gas fee
    - Transfer bug if not approved
*/