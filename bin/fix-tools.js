const fs = require('fs');
const path = require('path');
const CODE = 'var window = global;\n';

function process() {
    let filename = __dirname + path.sep + 'tools.js';
    let toolsCode = fs.readFileSync(filename).toString();
    if (toolsCode.startsWith(CODE)) {
        return;
    }
    toolsCode = CODE + toolsCode;
    fs.writeFileSync(filename, toolsCode);
}

process();