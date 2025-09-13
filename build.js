import { build } from 'esbuild';
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

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
      // Detect example type
      const mainTsPath = path.join(examplePath, 'main.ts');
      const reactIndexPath = path.join(examplePath, 'src', 'index.tsx');

      const isTsSingleFile = fs.existsSync(mainTsPath);
      const isReactTsx = fs.existsSync(reactIndexPath);

      if (!isTsSingleFile && !isReactTsx) {
        console.log(`⚠️  Skipping ${example}: no entry found (expected main.ts or src/index.tsx)`);
        continue;
      }

      // If the example is a React app with its own package.json, ensure deps are installed
      const examplePkgPath = path.join(examplePath, 'package.json');
      const hasPackageJson = fs.existsSync(examplePkgPath);
      const nodeModulesPath = path.join(examplePath, 'node_modules');
      if (isReactTsx && hasPackageJson && !fs.existsSync(nodeModulesPath)) {
        try {
          console.log(`📦 Installing dependencies for ${example} (bun install)...`);
          execSync('bun install --no-progress', { cwd: examplePath, stdio: 'inherit' });
          console.log(`✅ Dependencies installed for ${example}`);
        } catch (installErr) {
          console.warn(`⚠️  Failed to install dependencies for ${example}. Continuing with build...`);
        }
      }

      // Common esbuild options
      const esbuildCommon = {
        outfile: path.resolve(outputPath, 'main.js'),
        bundle: true,
        minify: true,
        format: 'esm',
        platform: 'browser',
        absWorkingDir: path.resolve(examplePath),
        loader: {
          '.ts': 'ts',
          '.tsx': 'tsx',
          '.css': 'css',
        },
        jsx: 'automatic',
        jsxImportSource: 'react',
        define: {
          'process.env.NODE_ENV': '"production"',
          'process.env.REACT_APP_WALLETCONNECT_PROJECT_ID': JSON.stringify(process.env.REACT_APP_WALLETCONNECT_PROJECT_ID || ''),
        },
      };

      if (isTsSingleFile) {
        await build({
          entryPoints: ['main.ts'],
          ...esbuildCommon,
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
      } else if (isReactTsx) {
        // Build React example from src/index.tsx
        const tsconfigPath = path.resolve(examplePath, 'tsconfig.json');
        await build({
          entryPoints: ['src/index.tsx'],
          tsconfig: fs.existsSync(tsconfigPath) ? tsconfigPath : undefined,
          ...esbuildCommon,
        });
        console.log(`✅ React example compiled for ${example}`);

        // Copy public assets
        const publicDir = path.join(examplePath, 'public');
        if (fs.existsSync(publicDir)) {
          // Copy everything except index.html (we'll transform it below)
          fs.readdirSync(publicDir).forEach(file => {
            const srcPath = path.join(publicDir, file);
            const destPath = path.join(outputPath, file);
            if (file.toLowerCase() === 'index.html') return;
            const stat = fs.statSync(srcPath);
            if (stat.isDirectory()) {
              fs.cpSync(srcPath, destPath, { recursive: true });
            } else {
              fs.copyFileSync(srcPath, destPath);
            }
          });
          console.log(`✅ Public assets copied for ${example}`);
        }

        // Copy all .css files from src/ to output directory (for React examples)
        const srcDir = path.join(examplePath, 'src');
        if (fs.existsSync(srcDir)) {
          const cssFiles = fs.readdirSync(srcDir).filter(f => f.endsWith('.css'));
          for (const cssFile of cssFiles) {
            fs.copyFileSync(path.join(srcDir, cssFile), path.join(outputPath, cssFile));
            console.log(`✅ src/${cssFile} copied for ${example}`);
          }
        }

        // Transform and write index.html
        const publicIndexHtml = path.join(publicDir, 'index.html');
        const cssFiles = fs.existsSync(srcDir) ? fs.readdirSync(srcDir).filter(f => f.endsWith('.css')) : [];
        if (fs.existsSync(publicIndexHtml)) {
          let html = fs.readFileSync(publicIndexHtml, 'utf8');
          // Replace CRA placeholders and inject script tag
          html = html.replace(/%PUBLIC_URL%/g, '.');
          // Inject CSS links if not present
          for (const cssFile of cssFiles) {
            if (!html.includes(cssFile)) {
              html = html.replace('</head>', `  <link rel="stylesheet" href="./${cssFile}">\n  </head>`);
            }
          }
          if (!/main\.js/.test(html)) {
            html = html.replace('</body>', '  <script type="module" src="./main.js"></script>\n  </body>');
          }
          fs.writeFileSync(path.join(outputPath, 'index.html'), html);
          console.log(`✅ HTML generated for ${example}`);
        } else {
          // Fallback basic HTML
          let cssLinks = cssFiles.map(cssFile => `    <link rel="stylesheet" href="./${cssFile}">`).join('\n');
          const basicHtml = `<!doctype html>\n<html>\n  <head>\n    <meta charset="utf-8"/>\n    <meta name="viewport" content="width=device-width, initial-scale=1"/>\n    <title>${example}</title>\n${cssLinks}\n  </head>\n  <body>\n    <div id="root"></div>\n    <script type="module" src="./main.js"></script>\n  </body>\n</html>`;
          fs.writeFileSync(path.join(outputPath, 'index.html'), basicHtml);
          console.log(`✅ HTML created for ${example}`);
        }
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