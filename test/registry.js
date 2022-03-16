const { Contract, ContractFactory, Signer, Wallet, utils } = require("ethers")
const { expect } = require("chai")
const { from18, to18, a, b, deploy, deployJSON } = require("../lib/utils")

describe("Registry", function () {
  let p, p2, p3
  let storage, registry

  beforeEach(async () => {
    ;[p, p2, p3] = await ethers.getSigners()
    storage = await deploy("EternalStorage")
    registry = await deploy("Registry", a(storage), "address_registry")
  })

  it("Should register addresses", async function () {
    await storage.grantRole(await storage.EDITOR_ROLE(), a(registry))
    await registry.add("test", a(p2))
    expect(await registry.get("test")).to.equal(a(p2))
    await registry.add("test2", a(p3))
    expect(await registry.get("test2")).to.equal(a(p3))
    expect(await registry.list()).to.eql(["test", "test2"])
    await registry.remove("test")
    expect(await registry.list()).to.eql(["", "test2"])
  })
})
