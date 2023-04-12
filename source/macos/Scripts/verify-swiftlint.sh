# Adds support for Apple Silicon brew directory
export PATH="$PATH:/opt/homebrew/bin"

if which swiftlint; then
    swiftlint --strict
else
    echo "error: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi