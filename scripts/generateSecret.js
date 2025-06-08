const crypto = require('crypto');

// Generate a cryptographically secure random string
function generateSecureSecret(length = 64) {
    return crypto.randomBytes(Math.ceil(length / 2))
        .toString('hex')
        .slice(0, length);
}
// Generate a 64-character secret by default

const secureSecret = generateSecureSecret();
console.log('Your cryptographically secure secret:');
console.log(secureSecret);
