import { MongoClient } from "mongodb";

const mongoHost = process.env.MONGODB_HOST || "mongodb-svc";
const mongoPort = process.env.MONGODB_PORT || "27017";
const mongoUser = process.env.MONGODB_USER || "admin";
const mongoPassword = process.env.MONGODB_PASSWORD || "admin123456";
const mongoDatabase = process.env.MONGODB_DATABASE || "mern-db";

const connectionString =
  process.env.ATLAS_URI ||
  `mongodb://${mongoUser}:${mongoPassword}@${mongoHost}:${mongoPort}/${mongoDatabase}?authSource=admin`;

const client = new MongoClient(connectionString);

let conn;

try {
  console.log(`Connecting to MongoDB at ${mongoHost}:${mongoPort}...`);
  conn = await client.connect();
  console.log("MongoDB connected successfully");
} catch (e) {
  console.error("MongoDB connection error:", e);
}

let db = conn.db(mongoDatabase);

export default db;