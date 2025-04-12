const twilio = require('twilio');

class TwilioService {
  constructor() {
    this.client = twilio(
      process.env.TWILIO_ACCOUNT_SID,
      process.env.TWILIO_AUTH_TOKEN
    );
  }

  async sendSMS(to, message) {
    try {
      const result = await this.client.messages.create({
        body: message,
        to,
        from: process.env.TWILIO_PHONE_NUMBER
      });
      return result;
    } catch (error) {
      console.error('Twilio error:', error);
      throw error;
    }
  }

  async verifyCredentials() {
    try {
      await this.client.messages.list({ limit: 1 });
      console.log('✅ Twilio credentials verified');
    } catch (error) {
      console.error('❌ Twilio credentials invalid:', error.message);
      throw error;
    }
  }
}

module.exports = new TwilioService(); 