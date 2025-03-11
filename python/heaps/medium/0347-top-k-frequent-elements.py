import heapq 

class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        maxHeap = []
        freq = Counter(nums)

        for key,value in freq.items():
            heapq.heappush(maxHeap,(-value,key))
        
        results = []
        for _ in range(k):
            key,value = heapq.heappop(maxHeap)
            results.append(value)

        return results
