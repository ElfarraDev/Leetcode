#!/bin/bash

validate_filename() {
    if ! [[ $1 =~ ^[0-9]{4}-[a-z0-9-]+\.(py|java|cpp)$ ]]; then
        echo "Error: Filename must be in the format XXXX-problem-name.ext (e.g., 0001-two-sum.py)"
        exit 1
    fi
}

validate_difficulty() {
    case $1 in
        easy|medium|hard) ;;
        *) echo "Error: Difficulty must be 'easy', 'medium', or 'hard'"; exit 1 ;;
    esac
}

update_readme() {
    local total=$1
    local easy=$2
    local medium=$3
    local hard=$4
    sed -i '' '/<!-- PROBLEM_COUNTS -->/c\<!-- PROBLEM_COUNTS -->Total LeetCode problems solved: '"$total"' - Easy: '"$easy"' - Medium: '"$medium"' - Hard: '"$hard"'"' README.md
    echo "Updated README.md with new problem counts."
}

push_to_github() {
    local problem_number=$1
    local problem_name=$2
    local language=$3
    local topic=$4
    local difficulty=$5
    git add "$folder/$filename" "$log_file" "README.md"
    git commit -m "Add solution for LeetCode $problem_number: $problem_name ($language, $topic, $difficulty)"
    git push origin main
    echo "Changes pushed to GitHub successfully."
}

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: Uncommitted changes detected. Please commit or stash them first."
    exit 1
fi

if ! git pull origin main; then
    echo "Error: Git pull failed. Please resolve any conflicts manually."
    exit 1
fi

if [ $# -lt 3 ] || [ $# -gt 5 ]; then
    echo "Usage: $0 <filename> <topic> <difficulty> [needs_review] [\"reflection\"]"
    echo "  or   $0 <filename> -unr yes|no"
    echo "  or   $0 <filename> -ur \"reflection\""
    echo "Example: $0 0036-valid-sudoku.py array medium"
    echo "         $0 0036-valid-sudoku.py array medium yes \"Used hash set for each row, column, and 3x3 box\""
    echo "         $0 0036-valid-sudoku.py -unr yes"
    echo "         $0 0036-valid-sudoku.py -ur \"Optimized solution using bitmasking\""
    exit 1
fi

filename=$1
validate_filename "$filename"
flag=${2:-}

log_file="leetcode_log.csv"

if [ ! -f "$log_file" ] || [ ! -s "$log_file" ]; then
    echo "Problem Number,Problem Name,Language,Topic,Difficulty,Link,Needs Review,Date Completed,Reflection" > "$log_file"
    echo "Created or reset $log_file with headers."
fi

problem_number=$(echo "$filename" | cut -d'-' -f1)
problem_name=$(echo "$filename" | sed -E 's/[0-9]+-(.+)\.[a-z]+/\1/')

extension="${filename##*.}"
case $extension in
    py) language="python" ;;
    java) language="java" ;;
    cpp) language="cpp" ;;
    *) echo "Error: Unsupported file extension: $extension"; exit 1 ;;
esac

if [ "$flag" = "-unr" ]; then
    # Update the 'Needs Review' status
    if [ "$3" != "yes" ] && [ "$3" != "no" ]; then
        echo "Error: -unr flag must be followed by 'yes' or 'no'."
        exit 1
    fi
    if ! grep -q "^$problem_number," "$log_file"; then
        echo "Error: Problem $problem_number not found in $log_file"
        exit 1
    fi
    awk -F, -v OFS=',' -v pnum="$problem_number" -v nr="$3" '
    $1 == pnum {$7=nr}
    {print}
    ' "$log_file" > temp.csv && mv temp.csv "$log_file"
    echo "Updated 'Needs Review' status for problem $problem_number to $3."
    push_to_github "$problem_number" "$problem_name" "$language" "N/A" "N/A"
elif [ "$flag" = "-ur" ]; then
    # Update the reflection
    if [ -z "$3" ]; then
        echo "Error: -ur flag must be followed by a reflection in quotes."
        exit 1
    fi
    if ! grep -q "^$problem_number," "$log_file"; then
        echo "Error: Problem $problem_number not found in $log_file"
        exit 1
    fi
    reflection_escaped=$(echo "$3" | sed 's/"/""/g')
    awk -F, -v OFS=',' -v pnum="$problem_number" -v refl="\"$reflection_escaped\"" '
    $1 == pnum {$9=refl}
    {print}
    ' "$log_file" > temp.csv && mv temp.csv "$log_file"
    echo "Updated reflection for problem $problem_number."
    push_to_github "$problem_number" "$problem_name" "$language" "N/A" "N/A"
else
    topic=$2
    difficulty=$3
    validate_difficulty "$difficulty"
    needs_review=${4:-no}
    reflection=${5:-"Initial solution"}
    
    problem_name_escaped=$(echo "$problem_name" | sed 's/"/""/g')
    reflection_escaped=$(echo "$reflection" | sed 's/"/""/g')
    
    link="https://leetcode.com/problems/$problem_name/"
    folder="$language/$topic/$difficulty"
    mkdir -p "$folder"
    
    if [ -f "$folder/$filename" ]; then
        echo "File $filename already exists in $folder/. Skipping file creation and README update."
        file_existed=true
    else
        if [ ! -f "$filename" ]; then
            touch "$folder/$filename"
            echo "# Add your solution for $problem_name here" > "$folder/$filename"
            echo "Created $filename in $folder/"
        else
            mv "$filename" "$folder/"
            echo "Moved $filename to $folder/"
        fi
        file_existed=false
    fi
    
    if grep -q "^$problem_number," "$log_file"; then
        awk -F, -v OFS=',' -v pnum="$problem_number" -v pname="\"$problem_name_escaped\"" -v lang="$language" -v top="$topic" -v diff="$difficulty" -v lnk="$link" -v nr="$needs_review" -v refl="\"$reflection_escaped\"" '
        $1 == pnum {$2=pname; $3=lang; $4=top; $5=diff; $6=lnk; $7=nr; $9=refl}
        {print}
        ' "$log_file" > temp.csv && mv temp.csv "$log_file"
        echo "Updated entry for problem $problem_number."
    else
        echo "$problem_number,\"$problem_name_escaped\",$language,$topic,$difficulty,$link,$needs_review,$(date +%Y-%m-%d),\"$reflection_escaped\"" >> "$log_file"
        echo "Added new entry for problem $problem_number."
    fi
    
    if [ "$file_existed" != true ]; then
        total=$(wc -l < "$log_file")
        total=$((total - 1))  # Subtract header
        easy=$(grep -c ",easy," "$log_file")
        medium=$(grep -c ",medium," "$log_file")
        hard=$(grep -c ",hard," "$log_file")
        update_readme "$total" "$easy" "$medium" "$hard"
    fi
    
    push_to_github "$problem_number" "$problem_name" "$language" "$topic" "$difficulty"
fi

echo "Local operations completed successfully!"
