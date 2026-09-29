---
source: https://windsurf.run/mcp/gcp
---

# Mcp Gcp

[GCP logo]

# GCP

A Model Context Protocol (MCP) server that enables AI assistants like Claude to interact with your
Google Cloud Platform environment. This allows for natural language querying and management of your
GCP resources during conversations.

[Installation Instructions][7]

# How to Use Model Context Protocol (MCP) in Codeium

## What is MCP?

Model Context Protocol (MCP) is a protocol that enables LLMs to access custom tools and services. An
MCP client (Cascade, in this case) can make requests to MCP servers to access tools that they
provide.

## Configuration Steps
1. Create Configuration File
   * Create a JSON file at ~/.codeium/windsurf/mcp_config.json
   * Quick access: Click the hammer icon in the Cascade toolbar, then click "Configure"
2. Configure MCP Servers
   * Specify servers in the JSON configuration
   * Include necessary arguments and environment variables

## Example Configuration

### Google Maps Server Example:

`{ "mcpServers": { "google-maps": { "command": "npx", "args": [ "-y",
"@modelcontextprotocol/server-google-maps" ], "env": { "GOOGLE_MAPS_API_KEY": "<YOUR_API_KEY>" } } }
}`

## Important Notes
* This feature is only available for paying individual users
* MCP tool calls will consume credits regardless of success or failure
* Only tools are supported (not prompts or resources)
* Tools that output images are not supported
* Only servers using the stdio transport type are supported

---

**Source:** https://windsurf.run/mcp/gcp
