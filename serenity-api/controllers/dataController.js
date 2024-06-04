import Data from '../models/DataModel.js'
import { StatusCodes } from 'http-status-codes'

export const getAllData = async (req, res) => {
  const data = await Data.find({ createdBy: req.user.userId })
  res.status(StatusCodes.OK).json({ data })
}

export const createData = async (req, res) => {
  req.body.createdBy = req.user.userId
  const data = await Data.create(req.body)
  res.status(StatusCodes.CREATED).json({ data })
}

export const getData = async (req, res) => {
  const data = await Data.findById(req.params.id)
  res.status(StatusCodes.OK).json({ data })
}

export const updateData = async (req, res) => {
  const updatedData = await Data.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
  })
  res.status(StatusCodes.OK).json({ msg: 'Data modified', data: updatedData })
}

export const deleteData = async (req, res) => {
  const removedData = await Data.findByIdAndDelete(req.params.id)
  res.status(StatusCodes.OK).json({ msg: 'Data deleted', data: removedData })
}
