namespace :d3 do
  D3_MODULES = %w(
    node_modules/d3/src/start.js
    node_modules/d3/src/arrays/max.js
    node_modules/d3/src/scale/linear.js
    node_modules/d3/src/selection/selection.js
    node_modules/d3/src/transition/transition.js
    node_modules/d3/src/end.js
  ).join(' ')

  desc "Build custom D3.js version"
  task build: :environment do
    `npm install`
    `node_modules/.bin/smash #{D3_MODULES} > vendor/assets/javascripts/d3.js`
  end
end
