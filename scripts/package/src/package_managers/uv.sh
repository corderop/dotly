uv::update_all() {
	tools=$(uv tool list | grep -v '^ *-' | awk '{print $1}')

	if [ -n "$tools" ]; then
		echo "$tools" | while IFS= read -r package; do
			output::write "🐍 $package"
			output::empty_line
			uv tool upgrade "$package" 2>&1 | log::file "Updating uv tool: $package"
		done
	else
		output::answer "Already up-to-date"
	fi
}
