import { body, param, validationResult } from 'express-validator'
import {
  BadRequestError,
  NotFoundError,
  UnauthenticatedError,
  UnauthorizedError,
} from '../errors/customErrors.js'
import { USER_GENDER } from '../utils/constants.js'
import mongoose from 'mongoose'
import Data from '../models/DataModel.js'
import User from '../models/UserModel.js'

const withValidationErrors = (validateValues) => {
  return [
    validateValues,
    (req, res, next) => {
      const errors = validationResult(req)
      if (!errors.isEmpty()) {
        const errorMessages = errors.array().map((error) => error.msg)
        if (errorMessages[0].startsWith('no job')) {
          throw new NotFoundError(errorMessages)
        }
        if (errorMessages[0].startsWith('not authorized')) {
          throw new UnauthorizedError('not authorized to access this route')
        }
        throw new BadRequestError(errorMessages)
      }
      next()
    },
  ]
}

export const validateDataInput = withValidationErrors([
  body('note').notEmpty().withMessage('note is required'),
  body('duration')
    .notEmpty()
    .withMessage('duration is required')
    .isInt({ min: 1 })
    .withMessage('duration must be a positive integer'),
  body('date')
    .isISO8601()
    .withMessage('date must be a valid ISO8601 date')
    .custom((value) => {
      if (new Date(value) > new Date()) {
        throw new Error('date cannot be in the future')
      }
      return true
    })
    .withMessage('date is required'),
])

export const validateIdParam = withValidationErrors([
  param('id').custom(async (value, { req }) => {
    const isValidId = mongoose.Types.ObjectId.isValid(value)
    if (!isValidId) throw new Error('invalid MongoDB id')

    const data = await Data.findById(value)
    if (!data) throw new Error(`no data with id ${value}`)

    const isAdmin = req.user.role === 'admin'
    const isOwner = req.user.userId === data.createdBy.toString()
    if (!isAdmin && !isOwner) {
      throw new Error('not authorized to access this route')
    }
  }),
])

export const validateRegisterInput = withValidationErrors([
  body('name').notEmpty().withMessage('name is required'),
  body('email')
    .notEmpty()
    .withMessage('email is required')
    .isEmail()
    .withMessage('invalid email format')
    .custom(async (email) => {
      const user = await User.findOne({ email })
      if (user) throw new Error('email already exists')
    }),
  body('password')
    .notEmpty()
    .withMessage('password is required')
    .isLength({ min: 8 })
    .withMessage('password must be at least 8 characters long'),
  body('gender')
    .isIn(Object.values(USER_GENDER))
    .withMessage('invalid gender value'),
])

export const validateLoginInput = withValidationErrors([
  body('email')
    .notEmpty()
    .withMessage('email is required')
    .isEmail()
    .withMessage('invalid email format'),
  body('password').notEmpty().withMessage('password is required'),
])

export const validateUpdateUserInput = withValidationErrors([
  body('name').notEmpty().withMessage('name is required'),
  body('email')
    .notEmpty()
    .withMessage('email is required')
    .isEmail()
    .withMessage('invalid email format')
    .custom(async (email, { req }) => {
      const user = await User.findOne({ email })
      if (user && user._id.toString() !== req.user.userId) {
        throw new Error('email already exists')
      }
    }),
  body('gender')
    .isIn(Object.values(USER_GENDER))
    .withMessage('invalid gender value'),
])
