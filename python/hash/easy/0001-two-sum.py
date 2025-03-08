class Solution:
    def twoSum(self,nums: List[int], target: int) -> List[int]:
        diff = {}

        for i in range(len(nums)):
            diff[nums[i]] = i
        
        for j in range(len(nums)):
            comp = target - nums[j]

            if comp in diff and diff[comp] != j:
                return [j,diff[comp]]
