// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.20;

// ███████╗███████╗██████╗  ██████╗
// ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗
//   ███╔╝ █████╗  ██████╔╝██║   ██║
//  ███╔╝  ██╔══╝  ██╔══██╗██║   ██║
// ███████╗███████╗██║  ██║╚██████╔╝
// ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝

// Website: https://zerolend.xyz
// Discord: https://discord.gg/zerolend
// Twitter: https://twitter.com/zerolendxyz

import {IOmnichainStaking} from "../../interfaces/IOmnichainStaking.sol";
import {IPoolVoter} from "../../interfaces/IPoolVoter.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract VotingPowerCombined is OwnableUpgradeable {
    IOmnichainStaking public lpStaking;
    IOmnichainStaking public tokenStaking;
    IPoolVoter public voter;

    function init(
        address _tokenStaking,
        address _lpStaking
    ) external reinitializer(1) {
        lpStaking = IOmnichainStaking(_lpStaking);
        tokenStaking = IOmnichainStaking(_tokenStaking);
    }

    function getVotes(address account) external view returns (uint256) {
        return lpStaking.getVotes(account) + tokenStaking.getVotes(account);
    }

    function getPastVotes(
        address account,
        uint256 timepoint
    ) external view returns (uint256) {
        return
            lpStaking.getPastVotes(account, timepoint) +
            tokenStaking.getPastVotes(account, timepoint);
    }

    function reset(address _who) external {
        require(
            msg.sender == _who ||
                msg.sender == address(lpStaking) ||
                msg.sender == address(tokenStaking),
            "invalid reset performed"
        );
        voter.reset(_who);
    }

    function getPastTotalSupply(
        uint256 timepoint
    ) external view returns (uint256) {
        return
            lpStaking.getPastTotalSupply(timepoint) +
            tokenStaking.getPastTotalSupply(timepoint);
    }
}
