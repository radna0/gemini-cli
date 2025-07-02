#!/bin/bash
set -e

# Define the installation directory
INSTALL_DIR="$HOME/.local/share/radna0-gemini-cli"
BIN_DIR="$HOME/.local/bin"
REPO_URL="https://github.com/radna0/gemini-cli.git"
CMD_NAME="gemini"

echo "Installing your custom Gemini CLI..."

# 1. Clone your specific repository
echo "Cloning repository from $REPO_URL..."
rm -rf "$INSTALL_DIR"
git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"

# 2. Build the project
echo "Building the project... (This may take a moment)"
cd "$INSTALL_DIR"
npm install
npm run build

# 3. Create the command (symbolic link)
echo "Creating the '$CMD_NAME' command..."
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/packages/cli/dist/index.js" "$BIN_DIR/$CMD_NAME-radna0-launcher"

# Create a small wrapper script to run with node
cat << 'EOF' > "$BIN_DIR/$CMD_NAME"
#!/bin/bash
node "$(dirname "$0")/$CMD_NAME-radna0-launcher" "$@"
EOF

chmod +x "$BIN_DIR/$CMD_NAME"

# 4. Final instructions
echo ""
echo "✅ Installation complete!"
echo ""
echo "Please ensure '$BIN_DIR' is in your shell's PATH."
echo "You can add it by running:"
echo "echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
echo ""
echo "You can now run your custom version with the command: gemini"
