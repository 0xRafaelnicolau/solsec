// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ERC721} from "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract VulnerableParty is ERC721 {
    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    error InvalidNumberOfOrganizers();
    error InvalidOrganizer();
    error InvitationAlreadyUsed();

    address[] public organizers;

    uint256 private _ticketId;
    mapping(bytes32 => bool) private _usedInvitations;

    constructor(address[] memory orgs) ERC721("Party Ticket", "PTK") {
        if (orgs.length == 0) revert InvalidNumberOfOrganizers();
        for (uint256 i; i < orgs.length; ++i) {
            if (orgs[i] == address(0)) revert InvalidOrganizer();
            organizers.push(orgs[i]);
        }
    }

    function mint(Signature[] calldata sigs) external {
        for (uint256 i; i < sigs.length; ++i) {
            Signature calldata sig = sigs[i];
            (bytes32 envitationHash, address organizer) = _verifySignature(organizers[i], msg.sender, sig);
            if (organizer != organizers[i]) revert InvalidOrganizer();
            if (_usedInvitations[envitationHash] == true) revert InvitationAlreadyUsed();

            _usedInvitations[envitationHash] = true;
        }
        _ticketId++;
        _safeMint(msg.sender, _ticketId);
    }

    function _verifySignature(address organizer, address to, Signature calldata sig)
        private
        pure
        returns (bytes32, address)
    {
        string memory header = "\x19Ethereum Signed Message:\n52";
        bytes32 messageHash = keccak256(abi.encodePacked(header, organizer, to));
        return (messageHash, ecrecover(messageHash, sig.v, sig.r, sig.s));
    }
}
