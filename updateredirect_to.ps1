$directoryPath = ".\_posts\*"

# Get all .html and .md files
$files = Get-ChildItem -Path $directoryPath -Include "*.html", "*.md" -Recurse

foreach ($file in $files) {
    Write-Host "Processing file: $($file.FullName)"
    $content = Get-Content $file.FullName -Raw

    # Adjusted regex for more flexibility with line endings and spaces
    $yamlPattern = "(?s)^\s*---\s*(.+?)\s*---"

    # Check if file contains YAML front matter
    if ($content -match $yamlPattern) {
        $yaml = $matches[1]
        Write-Host "Found YAML front matter."

        # Check for permalink in YAML
        if ($yaml -match "permalink:\s*(.+)") {
            $permalink = $matches[1].Trim()
            # Ensure permalink starts with a '/'
            if (-not $permalink.StartsWith("/")) {
                $permalink = "/" + $permalink
            }
            $redirectUrl = "https://www.autocrossblog.com$permalink"
            Write-Host "Found permalink: $permalink"

            # Add or update redirect_to in YAML
            if ($yaml -notmatch "redirect_to:") {
                $yaml = $yaml + "`nredirect_to:`n  - $redirectUrl"
                Write-Host "Added redirect_to."
            } else {
                $yaml = $yaml -replace "(?<=redirect_to:\s*\n\s*-).*", " $redirectUrl"
                Write-Host "Updated redirect_to."
            }

            # Replace old YAML with new YAML
            $newContent = $content -replace $yamlPattern, "---`n$yaml`n---"

            # Write the new content back to the file
            Set-Content -Path $file.FullName -Value $newContent
        } else {
            Write-Host "No permalink found in YAML."
        }
    } else {
        Write-Host "No YAML front matter found."
    }
}
