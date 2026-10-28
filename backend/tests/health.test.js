import request from "supertest";
import app from "../app.js";

describe("Health check endpoint", () => {
  it("GET /api/health should return status ok", async () => {
    const res = await request(app).get("/api/health");
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe("ok");
  });
});

describe("Unknown route", () => {
  it("GET /api/nonexistent should return 404", async () => {
    const res = await request(app).get("/api/nonexistent");
    expect(res.statusCode).toBe(404);
  });
});