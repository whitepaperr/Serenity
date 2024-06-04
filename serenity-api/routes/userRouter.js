import { Router } from 'express'
const router = Router()
import {
  getCurrentUser,
  getApplicationStats,
  updateUser,
} from '../controllers/userController.js'
import { validateUpdateUserInput } from '../middlewares/validationMiddleware.js'
import { authorizePermissions } from '../middlewares/authMiddleware.js'

router.get('/current-user', getCurrentUser)
router.get('/admin/app-stats', [
  authorizePermissions('admin'),
  getApplicationStats,
])
router.patch('/update-user', validateUpdateUserInput, updateUser)

export default router
