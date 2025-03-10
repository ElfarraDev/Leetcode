class Solution:
    def searchInsert(self, nums: List[int], target: int) -> int:
        left, right = 0 ,right -1

        while left <= right:
            mid = (left + right) // 2

            if nums[mid] == target:
                return target
            elif nums[mid] < target:
                left = mid + 1
            else:
                right = mid - 1

        return left
