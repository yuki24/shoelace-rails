process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const { webpackConfig } = require('@rails/webpacker')

module.exports = webpackConfig
