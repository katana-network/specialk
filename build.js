import { build } from 'esbuild';
import fs from 'node:fs';
import path from 'node:path';

async function buildProject() {
  console.log('🏗️ Building project...');

  // Ensure dist directory exists
  if (fs.existsSync('./dist')) {
    console.log('Cleaning dist directory...');
    fs.rmSync('./dist', { recursive: true, force: true });
  }
  fs.mkdirSync('./dist', { recursive: true });

  try {
    // Build TypeScript
    await build({
      entryPoints: ['./src/main.ts'],
      outfile: './dist/main.js',
      bundle: true,
      minify: true,
      format: 'esm',
      platform: 'browser',
      loader: {
        '.ts': 'ts',
      },
      define: {
        'process.env.NODE_ENV': '"production"',
      }
    });

    console.log('✅ TypeScript compiled successfully.');

    // Copy HTML file
    fs.copyFileSync('./src/index.html', './dist/index.html');
    console.log('✅ HTML files copied.');

    // Copy CSS file
    fs.copyFileSync('./src/style.css', './dist/style.css');
    console.log('✅ CSS files copied.');

    // Copy any other static assets if they exist
    const imagesDir = './src/images';
    if (fs.existsSync(imagesDir)) {
      const targetDir = './dist/images';
      if (!fs.existsSync(targetDir)) {
        fs.mkdirSync(targetDir, { recursive: true });
      }
      
      fs.readdirSync(imagesDir).forEach(file => {
        fs.copyFileSync(path.join(imagesDir, file), path.join(targetDir, file));
      });
      console.log('✅ Images copied.');
    }

    console.log('🎉 Build complete! Files written to ./dist');
  } catch (error) {
    console.error('❌ Build failed:', error);
    process.exit(1);
  }
}

async function buildMcpServer() {
  console.log('🏗️ Building MCP server...');

  // Ensure dist-mcp directory exists
  if (fs.existsSync('./dist-mcp')) {
    console.log('Cleaning dist-mcp directory...');
    fs.rmSync('./dist-mcp', { recursive: true, force: true });
  }
  fs.mkdirSync('./dist-mcp', { recursive: true });

  try {
    // Build MCP server
    await build({
      entryPoints: ['./utils/mcp-server/index.ts'],
      outfile: './dist-mcp/index.js',
      bundle: true,
      minify: false, // For easier debugging
      format: 'esm',
      platform: 'node',
      loader: {
        '.ts': 'ts',
      },
      external: ['child_process', 'fs', 'path', 'os', 'util'],
      define: {
        'process.env.NODE_ENV': '"production"',
      }
    });

    console.log('✅ MCP server compiled successfully.');

    // Create README for MCP server
    const mcpReadme = `# Katana Foundry MCP Server

This is a Model Context Protocol (MCP) server for Foundry that provides tools
for interacting with Katana blockchain via the command line.

## Usage

To use this MCP server with Cursor, add the following to your Cursor config:

\`\`\`json
"mcpServers": {
  "foundry": {
    "command": "bun",
    "args": [
      "${path.resolve('./dist-mcp/index.js')}"
    ],
    "env": {
      "PRIVATE_KEY": "0xYourPrivateKeyHere",
      "RPC_URL": "http://localhost:8545"
    }
  }
}
\`\`\`

The \`PRIVATE_KEY\` and \`RPC_URL\` environment variables are optional. If not provided,
the RPC URL will default to http://localhost:8545.
`;

    fs.writeFileSync('./dist-mcp/README.md', mcpReadme);
    console.log('✅ MCP server README created.');

  } catch (error) {
    console.error('❌ MCP server build failed:', error);
    process.exit(1);
  }
}

async function buildExamples() {
  console.log('🏗️ Building examples...');

  // Ensure dist-examples directory exists
  if (fs.existsSync('./dist-examples')) {
    console.log('Cleaning dist-examples directory...');
    fs.rmSync('./dist-examples', { recursive: true, force: true });
  }
  fs.mkdirSync('./dist-examples', { recursive: true });

  const examplesDir = './examples';
  
  if (!fs.existsSync(examplesDir)) {
    console.log('❌ Examples directory not found');
    return;
  }

  const examples = fs.readdirSync(examplesDir, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);

  if (examples.length === 0) {
    console.log('❌ No example directories found');
    return;
  }

  console.log(`📁 Found ${examples.length} examples: ${examples.join(', ')}`);

  for (const example of examples) {
    const examplePath = path.join(examplesDir, example);
    const outputPath = path.join('./dist-examples', example);
    
    console.log(`🔨 Building example: ${example}`);
    
    // Create output directory for this example
    fs.mkdirSync(outputPath, { recursive: true });
    
    try {
      // Check if main.ts exists
      const mainTsPath = path.join(examplePath, 'main.ts');
      if (!fs.existsSync(mainTsPath)) {
        console.log(`⚠️  Skipping ${example}: no main.ts found`);
        continue;
      }

      // Build TypeScript for this example
      await build({
        entryPoints: [mainTsPath],
        outfile: path.join(outputPath, 'main.js'),
        bundle: true,
        minify: true,
        format: 'esm',
        platform: 'browser',
        loader: {
          '.ts': 'ts',
        },
        define: {
          'process.env.NODE_ENV': '"production"',
        }
      });

      console.log(`✅ TypeScript compiled for ${example}`);

      // Copy HTML file if it exists
      const htmlPath = path.join(examplePath, 'index.html');
      if (fs.existsSync(htmlPath)) {
        fs.copyFileSync(htmlPath, path.join(outputPath, 'index.html'));
        console.log(`✅ HTML copied for ${example}`);
      }

      // Copy CSS file if it exists
      const cssPath = path.join(examplePath, 'style.css');
      if (fs.existsSync(cssPath)) {
        fs.copyFileSync(cssPath, path.join(outputPath, 'style.css'));
        console.log(`✅ CSS copied for ${example}`);
      }

      // Copy any images directory if it exists
      const imagesDir = path.join(examplePath, 'images');
      if (fs.existsSync(imagesDir)) {
        const targetImagesDir = path.join(outputPath, 'images');
        fs.mkdirSync(targetImagesDir, { recursive: true });
        
        fs.readdirSync(imagesDir).forEach(file => {
          fs.copyFileSync(path.join(imagesDir, file), path.join(targetImagesDir, file));
        });
        console.log(`✅ Images copied for ${example}`);
      }

      // Create a README for this example
      const exampleReadme = `# ${example.charAt(0).toUpperCase() + example.slice(1)} Example

This is a demo application showing how to use Katana blockchain features.

## Running the Demo

To run this demo:

1. Start a local HTTP server in this directory:
   \`\`\`bash
   npx http-server
   \`\`\`

2. Open your browser to http://localhost:PORT (port will vary based on other apps running)
`;

      fs.writeFileSync(path.join(outputPath, 'README.md'), exampleReadme);
      console.log(`✅ README created for ${example}`);

    } catch (error) {
      console.error(`❌ Failed to build example ${example}:`, error);
      // Continue with other examples instead of failing entirely
    }
  }

  console.log('🎉 Examples build complete! Files written to ./dist-examples');
  console.log('💡 To run an example: cd dist-examples/<example-name> && npx http-server');
}

// Run if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  if (process.argv.includes('--mcp-only')) {
    buildMcpServer();
  } else if (process.argv.includes('--examples-only')) {
    buildExamples();
  } else {
    buildProject();
  }
}

export { buildProject, buildMcpServer, buildExamples }; 