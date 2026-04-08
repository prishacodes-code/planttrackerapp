const admin = require("firebase-admin");
const data = require("./data.json");

// ------------------ INIT FIREBASE ------------------
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://planttracker-fb02b-default-rtdb.firebaseio.com"
});

const db = admin.database();

// ------------------ GET USER BY PHONE ------------------
function getUserByPhone(phone) {
    const ownerEntry = Object.entries(data.owners).find(
        ([id, o]) => o.phone === phone
    );
    if (ownerEntry) {
        return { id: ownerEntry[0], ...ownerEntry[1], collection: "owners" };
    }

    const workerEntry = Object.entries(data.workers).find(
        ([id, w]) => w.phone === phone
    );
    if (workerEntry) {
        return { id: workerEntry[0], ...workerEntry[1], collection: "workers" };
    }

    return null;
}

// ------------------ VERIFY OTP TOKEN ------------------
async function verifyOtpAndLogin(idToken) {
    try {
        const decoded = await admin.auth().verifyIdToken(idToken);
        const phone = decoded.phone_number;
        const uid = decoded.uid;

        if (!phone) {
            return { success: false, message: "No phone number in token" };
        }

        const user = getUserByPhone(phone);

        if (!user) {
            return { success: false, message: "Phone not registered in system" };
        }

        const ref = db.ref(`${user.collection}/${user.id}/uid`);
        const snapshot = await ref.once("value");

        if (!snapshot.val()) {
            await ref.set(uid);
            console.log(`UID saved for ${user.name}`);
        }

        return {
            success: true,
            user: {
                id: user.id,
                name: user.name,
                role: user.role,
                collection: user.collection
            }
        };

    } catch (err) {
        console.error("OTP verification failed:", err.message);
        return { success: false, message: "Invalid or expired token" };
    }
}

// ------------------ LINK UID MANUALLY ------------------
async function linkUidToUser(phone, uid) {
    const user = getUserByPhone(phone);
    if (!user) return { success: false, message: "Phone not found" };

    await db.ref(`${user.collection}/${user.id}/uid`).set(uid);
    return { success: true, message: `UID linked to ${user.name}` };
}

// ------------------ TEST ------------------
// verifyOtpAndLogin("PASTE_ID_TOKEN_HERE").then(console.log);

module.exports = { verifyOtpAndLogin, getUserByPhone, linkUidToUser };
