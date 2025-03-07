from collections import Counter

class Solution:
    def isAnagram(self,s: str, t: str) -> bool:
        if len(s) != len(t):
            return False
        d1 = Counter(s)
        d2 = Counter(t)

        for key in d1:
            if key not in d2 or d1[key] != d2[key]:
                return False

        return True

