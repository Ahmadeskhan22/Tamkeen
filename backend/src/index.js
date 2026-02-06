const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// In-memory storage for demo purposes only.
// In production, replace this with a real database.
let requests = [];
let nextId = 1;

function createRequest(type, payload) {
  const request = {
    id: nextId++,
    type,
    status: "pending",
    createdAt: new Date().toISOString(),
    payload,
  };

  requests.push(request);
  return request;
}

// Health check
app.get("/api/health", (req, res) => {
  res.json({ status: "ok", service: "hopesteps-backend" });
});

// List all requests (optionally filter by type)
app.get("/api/requests", (req, res) => {
  const { type } = req.query;
  const data = type ? requests.filter((r) => r.type === type) : requests;
  res.json(data);
});

// School supplies request
app.post("/api/requests/supplies", (req, res) => {
  const { grade, items, isUrgent, notes } = req.body || {};

  if (!grade || !Array.isArray(items) || items.length === 0) {
    return res
      .status(400)
      .json({ message: "grade and at least one item are required." });
  }

  const request = createRequest("school_supplies", {
    grade,
    items,
    isUrgent: !!isUrgent,
    notes: notes || "",
  });

  res.status(201).json(request);
});

// Meals request
app.post("/api/requests/meals", (req, res) => {
  const { grade, mealTypes, hasDietaryRestrictions, dietaryNotes } =
    req.body || {};

  if (!grade || !Array.isArray(mealTypes) || mealTypes.length === 0) {
    return res
      .status(400)
      .json({ message: "grade and at least one meal type are required." });
  }

  const request = createRequest("school_meals", {
    grade,
    mealTypes,
    hasDietaryRestrictions: !!hasDietaryRestrictions,
    dietaryNotes: dietaryNotes || "",
  });

  res.status(201).json(request);
});

// Tutoring request
app.post("/api/requests/tutoring", (req, res) => {
  const { grade, subjects, description } = req.body || {};

  if (!grade || !Array.isArray(subjects) || subjects.length === 0) {
    return res
      .status(400)
      .json({ message: "grade and at least one subject are required." });
  }

  const request = createRequest("volunteer_tutoring", {
    grade,
    subjects,
    description: description || "",
  });

  res.status(201).json(request);
});

// Uniform request
app.post("/api/requests/uniform", (req, res) => {
  const { grade, uniformSize, needWinterClothing, winterSize, notes } =
    req.body || {};

  if (!grade || !uniformSize) {
    return res
      .status(400)
      .json({ message: "grade and uniformSize are required." });
  }

  const request = createRequest("uniform_clothing", {
    grade,
    uniformSize,
    needWinterClothing: !!needWinterClothing,
    winterSize: winterSize || null,
    notes: notes || "",
  });

  res.status(201).json(request);
});

// Psychological support request
app.post("/api/requests/support", (req, res) => {
  const { supportType, isAnonymous, isUrgent, description } = req.body || {};

  if (!supportType || !description) {
    return res
      .status(400)
      .json({ message: "supportType and description are required." });
  }

  const request = createRequest("psychological_support", {
    supportType,
    isAnonymous: !!isAnonymous,
    isUrgent: !!isUrgent,
    description,
  });

  res.status(201).json(request);
});

// Fallback 404 handler
app.use((req, res) => {
  res.status(404).json({ message: "Not found" });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`HopeSteps backend listening on port ${PORT}`);
});
