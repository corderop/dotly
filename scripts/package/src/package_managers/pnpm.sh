pnpm::update_all() {
	outdated=$(pnpm outdated -g --format list)

	if [ -n "$outdated" ]; then
		package=""
		echo "$outdated" | while read -r line; do
			# Skip empty lines
			[ -z "$line" ] && continue

			# If the line doesn't contain '=>', it's a package name
			if [[ "$line" != *"=>"* ]]; then
				package="$line"
				continue
			fi

			# Otherwise, it's the versions line: current_version => new_version
			current_version=$(echo "$line" | awk '{print $1}')
			new_version=$(echo "$line" | awk '{print $3}')

			info=$(pnpm view "$package")
			summary=$(echo "$info" | sed -n '3p')
			url=$(echo "$info" | sed -n '4p')

			output::write "🌈 $package"
			output::write "├ $current_version -> $new_version"
			output::write "├ $summary"
			output::write "└ $url"
			output::empty_line

			pnpm install -g "$package" 2>&1 | log::file "Updating pnpm app: $package"
		done
	else
		output::answer "Already up-to-date"
	fi
}