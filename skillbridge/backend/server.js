/**
 * SkillBridge - Minimal Demo Backend (Node.js + Express)
 * ---------------------------------------------------------------
 * This is a small, self-contained REST API that demonstrates the
 * backend-integration concepts covered in the semester: routing,
 * JSON request/response bodies, CRUD endpoints and CORS.
 *
 * The Flutter app does NOT require this server to run (it ships with
 * a fully working on-device LocalSkillRepository), but pointing
 * `ApiSkillRepository(baseUrl: ...)` in lib/main.dart at this server
 * (or a deployed version of it) switches the whole app over to live,
 * networked data with no other code changes - illustrating the
 * repository pattern used throughout the project.
 *
 * Run with:
 *   cd backend
 *   npm install
 *   npm start
 *   -> Server listens on http://localhost:3000
 */
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// ---- In-memory "database" (seed data mirrors lib/utils/dummy_data.dart) ----
let skills = [
  {
    id: 's1',
    userId: 'u1',
    title: 'Custom Logo & Brand Design',
    category: 'Design & Art',
    description: 'I will design a clean, modern logo for your small business or personal brand.',
    type: 'skillSwap',
    price: null,
    wantedInExchange: 'Home-cooked meals or gardening help',
    location: 'F-10, Islamabad',
    postedDate: new Date().toISOString(),
    imageSeed: 'Custom Logo & Brand Design',
    rating: 4.8,
    completedCount: 12,
  },
  {
    id: 's2',
    userId: 'u2',
    title: 'Home Electrical Wiring & Repairs',
    category: 'Home Repair',
    description: 'Licensed electrician offering switchboard repair, wiring fixes and installation.',
    type: 'paidGig',
    price: 1500,
    wantedInExchange: null,
    location: 'Bahria Town, Rawalpindi',
    postedDate: new Date().toISOString(),
    imageSeed: 'Home Electrical Wiring & Repairs',
    rating: 4.6,
    completedCount: 27,
  },
];

// ---- Routes ----

// GET /api/skills - list all listings
app.get('/api/skills', (req, res) => {
  res.json(skills);
});

// GET /api/skills/:id - single listing
app.get('/api/skills/:id', (req, res) => {
  const skill = skills.find((s) => s.id === req.params.id);
  if (!skill) return res.status(404).json({ error: 'Skill not found' });
  res.json(skill);
});

// POST /api/skills - create a new listing
app.post('/api/skills', (req, res) => {
  const newSkill = { ...req.body, id: req.body.id || `s${Date.now()}` };
  skills.unshift(newSkill);
  res.status(201).json(newSkill);
});

// PUT /api/skills/:id - update a listing
app.put('/api/skills/:id', (req, res) => {
  const index = skills.findIndex((s) => s.id === req.params.id);
  if (index === -1) return res.status(404).json({ error: 'Skill not found' });
  skills[index] = { ...skills[index], ...req.body };
  res.json(skills[index]);
});

// DELETE /api/skills/:id - remove a listing
app.delete('/api/skills/:id', (req, res) => {
  const exists = skills.some((s) => s.id === req.params.id);
  if (!exists) return res.status(404).json({ error: 'Skill not found' });
  skills = skills.filter((s) => s.id !== req.params.id);
  res.status(204).send();
});

app.get('/', (req, res) => {
  res.send('SkillBridge demo API is running. Try GET /api/skills');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`SkillBridge demo API listening on http://localhost:${PORT}`);
});
