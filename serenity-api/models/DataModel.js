import mongoose from 'mongoose'

const DataSchema = new mongoose.Schema({
  createdBy: {
    type: mongoose.Types.ObjectId,
    ref: 'User',
  },
  date: {
    type: Date,
    default: Date.now,
  },
  note: {
    type: String,
  },
  duration: {
    type: Number, // Duration in minutes
  },
})

export default mongoose.model('Data', DataSchema)
