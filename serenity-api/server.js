import 'express-async-errors'
import * as dotenv from 'dotenv'
dotenv.config()

// extra security packages
import helmet from 'helmet'
import cors from 'cors'
import xss from 'xss-clean'
import rateLimiter from 'express-rate-limit'

import express from 'express'
const app = express()
import morgan from 'morgan'
import mongoose from 'mongoose'
import cookieParser from 'cookie-parser'

// routers
import dataRouter from './routes/dataRouter.js'
import userRouter from './routes/userRouter.js'
import authRouter from './routes/authRouter.js'

// middleware
import errorHandlerMiddleware from './middlewares/errorHandlerMiddleware.js'
import { authenticateUser } from './middlewares/authMiddleware.js'

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'))
}

app.use(cookieParser())
app.use(express.json())

app.use(
  rateLimiter({
    windowMs: 1 * 60 * 1000, // 1 minutes
    max: 500, // limit each IP to 100 requests per windowMs
  })
)
app.use(helmet())
app.use(cors())
app.use(xss())

app.get('/', (req, res) => {
  res.send('Hello World')
})

app.get('/api/v1/test', (req, res) => {
  res.json({ msg: 'test' })
})

app.use('/api/v1/data', authenticateUser, dataRouter)
app.use('/api/v1/users', authenticateUser, userRouter)
app.use('/api/v1/auth', authRouter)

app.use('*', (req, res) => {
  res.status(404).json({ msg: 'not found' })
})

app.use(errorHandlerMiddleware)

const port = process.env.PORT || 5100

try {
  await mongoose.connect(process.env.MONGO_URL)
  app.listen(port, () => {
    console.log(`server running on PORT ${port}...`)
  })
} catch (error) {
  console.log(error)
  process.exit(1)
}
