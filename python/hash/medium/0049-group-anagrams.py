from collections import defaultdict

class Solution:
    def groupAnagrams(self,strs: List[str]) -> List[List[str]]:
        if not strs:
            return [[]]
        
        group = defaultdict(list)

        for word in strs:
            sortedWord = ''.join(sortedWord)
            group[sortedWord].append(word)

        return [v for k,v in group.items)]
