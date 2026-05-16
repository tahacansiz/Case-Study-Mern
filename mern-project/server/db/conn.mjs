import { MongoClient } from "mongodb";

const connectionString =
  process.env.ATLAS_URI ||
  "mongodb://admin:password@mongodb:27017/sample_training?authSource=admin";

const client = new MongoClient(connectionString);

let conn;

try {
  console.log("Connecting to MongoDB...");
  conn = await client.connect();
  console.log("MongoDB connected successfully");
} catch (e) {
  console.error(e);
}

let db = conn.db("sample_training");

export default db;