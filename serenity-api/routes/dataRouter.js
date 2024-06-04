import { Router } from 'express'
const router = Router()
import {
  getAllData,
  getData,
  createData,
  updateData,
  deleteData,
} from '../controllers/dataController.js'
import {
  validateDataInput,
  validateIdParam,
} from '../middlewares/validationMiddleware.js'

router.route('/').get(getAllData).post(validateDataInput, createData)
router
  .route('/:id')
  .get(validateIdParam, getData)
  .patch(validateDataInput, validateIdParam, updateData)
  .delete(validateIdParam, deleteData)

export default router
