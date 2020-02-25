import http from 'http'
import socketio from 'socket.io'

let server = http.Server()
let io = socketio(server)

server.listen('8787', '192.168.0.194')

io.on('connect', (socket) => {
  console.log('==')
  socket.on('mobile-update', (data) => {
    console.log(data)
  })
})
