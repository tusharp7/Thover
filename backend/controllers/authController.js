const User = require('../models/User');
const twilioService = require('../services/twilioService');
const otpService = require('../services/otpService');
const catchAsync = require('../utils/catchAsync');

exports.sendOTP = catchAsync(async (req, res) => {
  const { phoneNumber } = req.body;

  if (!phoneNumber) {
    return res.status(400).json({
      success: false,
      message: 'Phone number is required'
    });
  }

  const otp = otpService.generateOTP();
  
  await twilioService.sendSMS(
    phoneNumber,
    `Your verification code is: ${otp}`
  );

  otpService.storeOTP(phoneNumber, otp);

  res.json({
    success: true,
    message: 'OTP sent successfully'
  });
});

exports.verifyOTP = catchAsync(async (req, res) => {
  const { phoneNumber, otp, userData } = req.body;

  const verification = otpService.verifyOTP(phoneNumber, otp);
  if (!verification.valid) {
    return res.json({
      success: false,
      message: verification.message
    });
  }

  const existingUser = await User.findOne({
    $or: [
      { userId: userData.userId },
      { phoneNumber: userData.phoneNumber }
    ]
  });

  if (existingUser) {
    return res.json({
      success: false,
      message: existingUser.userId === userData.userId
        ? 'User ID already exists'
        : 'Phone number already registered'
    });
  }

  const newUser = await User.create({
    username: userData.username,
    userId: userData.userId,
    password: userData.password,
    phoneNumber: userData.phoneNumber
  });

  res.json({
    success: true,
    message: 'Registration successful'
  });
});

exports.login = catchAsync(async (req, res) => {
  const { userId, password } = req.body;

  const user = await User.findOne({ userId });
  if (!user || !(await user.comparePassword(password))) {
    return res.json({
      success: false,
      message: 'Invalid credentials'
    });
  }

  res.json({
    success: true,
    message: 'Login successful',
    user: {
      username: user.username,
      userId: user.userId,
      phoneNumber: user.phoneNumber
    }
  });
}); 