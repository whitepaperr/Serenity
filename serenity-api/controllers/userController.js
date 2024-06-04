import { StatusCodes } from 'http-status-codes'
import User from '../models/UserModel.js'
import Data from '../models/DataModel.js'
import { hashPassword } from '../utils/passwordUtils.js'

export const getCurrentUser = async (req, res) => {
  const user = await User.findOne({ _id: req.user.userId })
  const userWithoutPassword = user.toJSON()
  res.status(StatusCodes.OK).json({ user: userWithoutPassword })
}
export const getApplicationStats = async (req, res) => {
  const users = await User.countDocuments()
  const data = await Data.countDocuments()
  res.status(StatusCodes.OK).json({ users, data })
}
export const updateUser = async (req, res) => {
  const obj = { ...req.body }
  // delete obj.password
  obj.password = await hashPassword(req.body.password)
  const updatedUser = await User.findByIdAndUpdate(req.user.userId, obj)
  res.status(StatusCodes.OK).json({ msg: 'update user' })
}
