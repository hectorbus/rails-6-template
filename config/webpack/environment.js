const { environment } = require('@rails/webpacker');

const exposeLoader = require('./loaders/expose');
environment.loaders.append('expose', exposeLoader);

module.exports = environment;
