import mongoose from 'mongoose'
import { USER_GENDER } from '../utils/constants.js'

const UserSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
  gender: {
    type: String,
    enum: Object.values(USER_GENDER),
  },
  role: {
    type: String,
    enum: ['user', 'admin'],
    default: 'user',
  },
})

UserSchema.methods.toJSON = function () {
  let obj = this.toObject()
  delete obj.password
  return obj
}

export default mongoose.model('User', UserSchema)
