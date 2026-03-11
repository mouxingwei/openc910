#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync, spawn } = require('child_process');

const DEFAULT_WIDTH = 2048;
const DEFAULT_HEIGHT = 1024;
const DEFAULT_BACKGROUND = 'white';

function parseArgs() {
    const args = process.argv.slice(2);
    const options = {
        input: null,
        output: null,
        width: DEFAULT_WIDTH,
        height: DEFAULT_HEIGHT,
        background: DEFAULT_BACKGROUND,
        theme: 'default',
        config: null,
        help: false
    };

    for (let i = 0; i < args.length; i++) {
        switch (args[i]) {
            case '-i':
            case '--input':
                options.input = args[++i];
                break;
            case '-o':
            case '--output':
                options.output = args[++i];
                break;
            case '-w':
            case '--width':
                options.width = parseInt(args[++i], 10);
                break;
            case '-H':
            case '--height':
                options.height = parseInt(args[++i], 10);
                break;
            case '-b':
            case '--background':
                options.background = args[++i];
                break;
            case '-t':
            case '--theme':
                options.theme = args[++i];
                break;
            case '-C':
            case '--config':
                options.config = args[++i];
                break;
            case '-h':
            case '--help':
                options.help = true;
                break;
            default:
                console.error(`Unknown option: ${args[i]}`);
                process.exit(1);
        }
    }

    return options;
}

function printHelp() {
    console.log(`
Mermaid to PNG Converter

Usage: node mermaid_to_png.js -i <input> -o <output> [options]

Options:
  -i, --input <file>      Input Mermaid file (.mmd or .md with mermaid code)
  -o, --output <file>     Output PNG file
  -w, --width <pixels>    Image width (default: ${DEFAULT_WIDTH})
  -H, --height <pixels>   Image height (default: ${DEFAULT_HEIGHT})
  -b, --background <color> Background color (default: ${DEFAULT_BACKGROUND})
  -t, --theme <theme>     Theme: default, dark, forest, neutral (default: default)
  -C, --config <file>     Path to mermaid config JSON file
  -h, --help              Show this help message

Examples:
  node mermaid_to_png.js -i diagram.mmd -o diagram.png
  node mermaid_to_png.js -i diagram.mmd -o diagram.png -w 4096 -b transparent
  node mermaid_to_png.js -i diagram.mmd -o diagram.png -t dark
`);
}

function checkMmdcInstalled() {
    try {
        execSync('mmdc --version', { stdio: 'ignore' });
        return true;
    } catch (error) {
        return false;
    }
}

function installMmdc() {
    console.log('mermaid-cli (mmdc) not found. Installing...');
    try {
        execSync('npm install -g @mermaid-js/mermaid-cli', { stdio: 'inherit' });
        console.log('mermaid-cli installed successfully.');
        return true;
    } catch (error) {
        console.error('Failed to install mermaid-cli:', error.message);
        return false;
    }
}

function extractMermaidFromMarkdown(content) {
    const mermaidRegex = /```mermaid\s*([\s\S]*?)```/g;
    const matches = [];
    let match;
    
    while ((match = mermaidRegex.exec(content)) !== null) {
        matches.push(match[1].trim());
    }
    
    return matches;
}

function convertMermaidToPng(options) {
    const { input, output, width, height, background, theme, config } = options;
    
    if (!fs.existsSync(input)) {
        console.error(`Input file not found: ${input}`);
        process.exit(1);
    }

    const inputContent = fs.readFileSync(input, 'utf8');
    const inputExt = path.extname(input).toLowerCase();
    
    let mermaidContent = inputContent;
    let tempFile = null;
    
    if (inputExt === '.md') {
        const mermaidBlocks = extractMermaidFromMarkdown(inputContent);
        if (mermaidBlocks.length === 0) {
            console.error('No mermaid code blocks found in the markdown file.');
            process.exit(1);
        }
        if (mermaidBlocks.length > 1) {
            console.log(`Found ${mermaidBlocks.length} mermaid blocks. Converting the first one.`);
        }
        mermaidContent = mermaidBlocks[0];
        tempFile = path.join(path.dirname(output), '_temp_diagram.mmd');
        fs.writeFileSync(tempFile, mermaidContent);
    }

    const inputFile = tempFile || input;
    
    const mmdcArgs = [
        '-i', inputFile,
        '-o', output,
        '-w', width.toString(),
        '-H', height.toString(),
        '-b', background
    ];
    
    if (theme !== 'default') {
        mmdcArgs.push('-t', theme);
    }
    
    if (config) {
        mmdcArgs.push('-C', config);
    }

    console.log(`Converting ${input} to ${output}...`);
    console.log(`Command: mmdc ${mmdcArgs.join(' ')}`);

    try {
        execSync(`mmdc ${mmdcArgs.join(' ')}`, { stdio: 'inherit' });
        console.log(`Successfully created: ${output}`);
        
        if (tempFile) {
            fs.unlinkSync(tempFile);
        }
        
        return true;
    } catch (error) {
        console.error('Failed to convert mermaid to PNG:', error.message);
        
        if (tempFile && fs.existsSync(tempFile)) {
            fs.unlinkSync(tempFile);
        }
        
        return false;
    }
}

function convertMermaidStringToPng(mermaidString, outputPath, options = {}) {
    const {
        width = DEFAULT_WIDTH,
        height = DEFAULT_HEIGHT,
        background = DEFAULT_BACKGROUND,
        theme = 'default'
    } = options;

    const tempFile = path.join(path.dirname(outputPath), '_temp_diagram.mmd');
    fs.writeFileSync(tempFile, mermaidContent);

    const success = convertMermaidToPng({
        input: tempFile,
        output: outputPath,
        width,
        height,
        background,
        theme
    });

    return success;
}

async function main() {
    const options = parseArgs();

    if (options.help) {
        printHelp();
        process.exit(0);
    }

    if (!options.input || !options.output) {
        console.error('Error: Input and output files are required.');
        printHelp();
        process.exit(1);
    }

    if (!checkMmdcInstalled()) {
        if (!installMmdc()) {
            console.error('Please install mermaid-cli manually: npm install -g @mermaid-js/mermaid-cli');
            process.exit(1);
        }
    }

    const success = convertMermaidToPng(options);
    process.exit(success ? 0 : 1);
}

module.exports = {
    convertMermaidToPng,
    convertMermaidStringToPng,
    extractMermaidFromMarkdown
};

if (require.main === module) {
    main();
}
