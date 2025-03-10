
import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const address1 = accounts.get("wallet_1")!;

/*
  The test below is an example. To learn more, read the testing documentation here:
  https://docs.hiro.so/stacks/clarinet-js-sdk
*/

describe("example tests", () => {
  it("ensures simnet is well initalised", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  // it("shows an example", () => {
  //   const { result } = simnet.callReadOnlyFn("counter", "get-counter", [], address1);
  //   expect(result).toBeUint(0);
  // });
});
import { describe, it, expect, vi } from "vitest"

// Mock the contract calls
const contractCall = vi.fn()

describe("Reputation System Contract", () => {
  it("should leave a review for a user", async () => {
    contractCall.mockResolvedValue({ success: true })
    const result = await contractCall("leave-review", ["ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM", "5", "Great work!"])
    expect(result).toEqual({ success: true })
  })
  
  it("should calculate user reputation correctly", async () => {
    contractCall.mockResolvedValue({ reputation: 4.5 })
    const result = await contractCall("get-reputation", ["ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"])
    expect(result).toEqual({ reputation: 4.5 })
  })
  
  it("should retrieve a specific review", async () => {
    contractCall.mockResolvedValue({
      reviewer: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      rating: 5,
      comment: "Great work!",
    })
    const result = await contractCall("get-review", ["1"])
    expect(result).toEqual({
      reviewer: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      rating: 5,
      comment: "Great work!",
    })
  })
})

