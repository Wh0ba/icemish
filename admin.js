// Import the Firebase Admin SDK
const admin = require('firebase-admin');

// Replace with the path to your service account key JSON file
const serviceAccount = require('');

// Initialize the Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// The UID of the user you want to set as an admin
const uid = '';

// Function to set custom claims for the user
async function setAdmin(uid) {
  try {
    // Set custom user claims
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    console.log(`Successfully set user ${uid} as admin.`);
  } catch (error) {
    console.error('Error setting custom claims:', error);
  }
}

// Call the function
setAdmin(uid);
