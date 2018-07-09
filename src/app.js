const Koa = require('koa')
const app = new Koa()

app.use(async (ctx, next) => {
  const name = process.env.HELLO_NAME
  ctx.body = `Hello ${name}`
})

// GAEでリスンするときにホストを指定してリスンするとLBからつながらなかったのでポートのみ指定する
const port = process.env.PORT || 8080
console.log(`start listening on :${port}`)
app.listen(port)
