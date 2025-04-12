const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.post('/check-userid', userController.checkUserId);
router.get('/profile/:userId', userController.getUserProfile);

module.exports = router; 