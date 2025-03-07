# LeetCode Solutions Repository

<!-- PROBLEM_COUNTS -->Total LeetCode problems solved: 5 - Easy: 5 - Medium: 0 - Hard: 0

This repository contains my solutions to various LeetCode problems, organized by programming language, topic, and difficulty level. It also includes a script to automate the process of adding new solutions, updating a CSV log, and keeping the README up-to-date with problem counts.

### Table of Contents
- [Repository Structure](#repository-structure)
- [Usage](#usage)
- [Supported Languages and Topics](#supported-languages-and-topics)
- [Contributing](#contributing)

---

# Repository Structure

```text
leetcode-solutions/
│
├── python/
│   ├── arrays/
│   │   ├── easy/
│   │   ├── medium/
│   │   └── hard/
│   ├── linked-lists/
│   │   ├── easy/
│   │   ├── medium/
│   │   └── hard/
│   └── ...
│
├── java/
│   ├── trees/
│   │   ├── easy/
│   │   ├── medium/
│   │   └── hard/
│   └── ...
│
├── cpp/
│   ├── graphs/
│   │   ├── easy/
│   │   ├── medium/
│   │   └── hard/
│   └── ...
│
├── contests/
│   └── ...
│
└── leetcode-push.sh
```

# Usage

- Language Folders: Solutions are first grouped by programming language (e.g., `python/`, `java/`, `cpp/`).  
- Topic Folders: Within each language, solutions are categorized by topic (e.g., `arrays/`, `linked-lists/`, `trees/`, `graphs/`, etc.).  
- Difficulty Folders: Each topic contains subfolders for difficulty levels: `easy/`, `medium/`, and `hard/`.  
- Contests: The `contests/` folder contains solutions to LeetCode contest problems, if applicable.

To add a new solution or update an existing one, use the `leetcode-push.sh` script. The script supports solutions in Python (`.py`), Java (`.java`), and C++ (`.cpp`).

# Adding a New Solution

Save your solution in the repository root with the naming format: `XXXX-problem-name.ext`, where `XXXX` is the problem number, and `ext` is the file extension (e.g., `0001-two-sum.py`).

Run the script with the following arguments:

```bash
./leetcode-push.sh <filename> <topic> <difficulty> [needs_review] ["reflection"]


<filename>: The name of your solution file (e.g., 0001-two-sum.py).
<topic>: The topic of the problem (e.g., arrays, linked-lists, trees, graphs, etc.).
<difficulty>: The difficulty level (easy, medium, hard).
[needs_review]: Optional. Set to yes if the solution needs further review, otherwise no (default).
["reflection"]: Optional. A brief reflection or note about the solution (e.g., "Used two-pointer technique").
```

### Example

```bash
./leetcode-push.sh 0001-two-sum.py arrays easy yes "Used a hash map for O(n) time complexity"
```

This will:
- Move the file to the appropriate folder (e.g., python/arrays/easy/).
- Update the CSV log (leetcode_log.csv) with problem details.
- Update the README with the latest problem counts.
- Commit and push the changes to GitHub.

# Updating an Existing Solution

### Update 'Needs Review' Status:

```bash
./leetcode-push.sh <filename> -unr yes|no

./leetcode-push.sh 0001-two-sum.py -unr yes
```

### Update Reflection:

```bash
./leetcode-push.sh <filename> -ur "new reflection"

./leetcode-push.sh 0001-two-sum.py -ur "Optimized with two-pointer technique"
```

- These commands will update the corresponding fields in the CSV log and push the changes to GitHub.
- Note: The script handles Git operations, including merging if there are differences between your local and remote branches. 
- Ensure you have write access to the repository and that your local Git is properly configured.

# Supported Languages and Topics
- Languages: Python (.py), Java (.java), C++ (.cpp)
- Topics: Arrays, Linked Lists, Trees, Graphs, Dynamic Programming, and more.

# Contributing
This repository is primarily for my personal LeetCode solutions. However, if you spot any errors or have suggestions for improvements, feel free to open an issue.

