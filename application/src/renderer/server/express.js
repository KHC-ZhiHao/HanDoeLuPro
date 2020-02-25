const ip = require('ip')
const app = require('express')()
const https = require('http').createServer(app)
const socket = require('socket.io')(https)

https.listen(8080, 'localhost', () => {
  app.get('/', (req, res) => {
    res.send('Node Server is running. Yay!!')
  })

  socket.on('connection', user => {
    console.log('ouo')
    user.on('mobile-update', (data) => {
      console.log(data)
    })
  })

  console.log('done =>', ip.address())
})
