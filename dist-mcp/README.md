# Katana Foundry MCP Server

This is a Model Context Protocol (MCP) server for Foundry that provides tools
for interacting with Katana blockchain via the command line.

## Usage

To use this MCP server with Cursor, add the following to your Cursor config:

```json
"mcpServers": {
  "foundry": {
    "command": "bun",
    "args": [
      "/Users/dhananjaypai/Coding/Personal/specialk/dist-mcp/index.js"
    ],
    "env": {
      "PRIVATE_KEY": "0xYourPrivateKeyHere",
      "RPC_URL": "http://localhost:8545"
    }
  }
}
```

The `PRIVATE_KEY` and `RPC_URL` environment variables are optional. If not provided,
the RPC URL will default to http://localhost:8545.
