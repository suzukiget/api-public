mkdir -p docs
node ./node_modules/aglio/bin/aglio.js -i apib/api.apib --theme-template triple -o docs/index.html
