#!/usr/bin/env bash
# Count toll plazas in toll.txt by state name (case-insensitive).
# Matches only the "Plaza State" column (last column), not text elsewhere in the line.
# Usage: ./toll_count.sh

TOLL_FILE="${TOLL_FILE:-toll.txt}"

echo "Enter the state name"
read -r name

# Trim leading/trailing whitespace and strip carriage return (e.g. from paste)
name="${name//$'\r'/}"
name="${name#"${name%%[![:space:]]*}"}"
name="${name%"${name##*[![:space:]]}"}"

# Validate: allow only letters, space, hyphen, apostrophe (no regex - works on all bash/sh)
valid=1
if [ -z "$name" ]; then
	valid=0
else
	apos=$'\047'
	i=0
	while [ "$i" -lt "${#name}" ]; do
		c="${name:$i:1}"
		case "$c" in
			[a-zA-Z]) ;;
			" "|-|$apos) ;;
			*) valid=0; break ;;
		esac
		i=$((i + 1))
	done
fi
if [ "$valid" -eq 0 ]; then
	echo "Invalid state name. Use only letters, spaces, hyphens, and apostrophes."
	exit 1
fi

if [[ ! -f "$TOLL_FILE" ]]; then
	echo "Error: File '$TOLL_FILE' not found."
	exit 1
fi

# Count only lines where the last column (Plaza State) exactly matches the state name (case-insensitive).
# This avoids matching substrings in other columns (e.g. "eagle" inside Concessionaire or Plaza Name).
i=$(awk -F',' -v state="$name" '
	NR > 1 {
		col = $NF
		gsub(/^[ \t]+|[ \t]+$/, "", col)
		if (tolower(col) == tolower(state)) count++
	}
	END { print count + 0 }
' "$TOLL_FILE")

if [[ "$i" -gt 0 ]]; then
	echo "The count of toll plaza in the search state $name is $i"
else
	echo "The state name $name is invalid or there are no toll plaza in entire state"
fi
