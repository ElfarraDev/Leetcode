class Solution:
    def numJewelInStones(self, jewels: str, stones: str) -> int:
        count = 0 
        seen = set(jewel)

        for stone in stones:
            if stone in seen:
                count += 1

        return count
