#!/bin/bash

# Initialize the project
npm init
# Install all the base packages
npm install --save-dev eslint eslint-config-airbnb-base eslint-plugin-import husky jest nodemon

# create the default files
touch .dockerignore
touch .editorconfig
touch .eslintrc.js
touch .gitignore
touch app.js

# Init the project with a app.js
echo "console.log('Hello world!');
" >> app.js

# Inject the proper values
echo "node_modules/
.nyc_output/
coverage/
config/
config_test" >> .dockerignore

echo "root = true

[*]
charset = utf-8
indent_style = space
indent_size = 2
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true" >> .editorconfig

echo "module.exports = {
  env: {
    jest: true,
  },
  extends: 'airbnb-base',
};" >> .eslintrc.js

echo "config
node_modules
coverage" >> .gitignore

# Finally install the husky pre-push hook
echo "const fs = require('fs');
const rawData = fs.readFileSync('package.json');
const jsonData = JSON.parse(rawData);
// add the husky hook
jsonData.husky = { hooks: { 'pre-push': 'npx eslint -c .eslintrc.js --ext .js ./ && CI=true npm run test:ci' } };
// modify the test scripts
jsonData.scripts = { start: 'nodemon app.js', 'start:prod': 'node app.js', test: 'jest -i --watchAll', 'test:ci': 'jest -i --coverage --forceExit' }
const outputData = JSON.stringify(jsonData, null, 2);
fs.writeFileSync('package.json', outputData);" >> createHusky.js

node createHusky.js
rm createHusky.js
