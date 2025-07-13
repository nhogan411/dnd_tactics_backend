# DnD Tactics Game: Project Overview

This document outlines the architecture, features, goals, and current progress of the Dungeons & Dragons 5e-inspired turn-based tactics game, with a Ruby on Rails backend and a browser-based frontend.

---

## ✅ Core Features Implemented

### 🧑‍🤝‍🧑 User System
- Users register with first name, last name, email, and password.
- Authentication will be managed by Devise (not wired yet).
- Users can add and manage multiple characters.

### 🧙 Character Creation
- Characters belong to Users.
- Can be assigned:
  - Race and Subrace (Human, Elf, Dwarf and subraces)
  - Class and Subclass (Barbarian, Fighter, Rogue)
  - Ability Scores (randomly generated or customized)
  - Equipment (limited by slot and strength-based inventory weight)
  - Level (supports multiclassing)
- Characters have:
  - Max HP / Current HP
  - Movement speed (based on race)
  - Vision/visibility range (for fog of war)

### 📚 Multiclassing
- Implemented using `CharacterClassLevel` model.
- Characters can belong to multiple classes with different levels.
- Primary class is the one with the highest level.

### ⚔️ Items & Inventory
- All standard PHB items seeded.
- Types: weapons, armor, gloves, boots, rings, necklaces, etc.
- Each item has weight, slot type, and basic metadata.
- Characters can carry items based on strength and equip 1 per slot.
- Equipped items and unequipped inventory tracked separately.

### 🧠 Abilities
- Class-based abilities implemented (e.g., Rage, Sneak Attack).
- Supports activation, cooldowns, status effects.
- Managed via `AbilityService`.

### 🎯 Battles
- Battles support 3v3 matches between users or vs AI.
- Battle board is 100x100 squares, each square = 5ft.
- Characters placed on starting squares (5 per team).
- Supports:
  - Turn order via initiative
  - Movement (grid-based, speed-limited)
  - Attack (basic targeting)
  - Ability usage
- Fog of war system limits visibility based on character/race.
- Battle logs capture all actions.

### 🧩 Board & Environment
- `BattleBoard` model defines terrain:
  - Each square has height, surface type, brightness.
  - Starting square options are saved per team.

### 🤖 AI Opponent
- Battles can flag for AI opponent.
- AI behavior is structured via strategy types.
- Tactical diversity and difficulty planned.

### 📊 Turn Management
- `TurnManager` handles initiative and next turn order.
- `TurnSubmissionService` accepts moves/attacks/abilities from users.
- WebSocket broadcasting planned for live updates.

### 🔐 Authorization & Validation
- Pundit used for all user-level access control.
- Character creation validates class/race/item rules.
- Participants validated to prevent user from exceeding 3 per battle.

### 🌐 Networking Features
- Friend system (add/remove/view friends).
- Invite other users to battle.
- Battle history per user (W/L/duration/characters used).

---

## 🔄 In Progress

### ✅ Implemented but Testing
- Friend and invite controllers
- Turn order edge case handling (dead characters, round wraps)

### 🏗️ Mid-Implementation
- More abilities from all three classes
- Dynamic starting square logic for each battle board

### 🔜 Queued
- Trait-based AI behavior strategies
- Strategy Analyzer (user + AI behavior profiling)
- Enum/tag-based tactics mapping for AI logic
- Visibility-aware targeting and movement

---

## 🛠 Services Implemented
- `BattleInitializerService`: Initializes battle, assigns teams, generates turn order.
- `TurnSubmissionService`: Handles incoming player turns.
- `MovementService`: Validates and executes move actions.
- `AttackService`: Manages attacks and damage.
- `AbilityService`: Activates and resolves character abilities.
- `BattleLogger`: Records battle events.
- `DiceRoller`: Utility for simulating dice rolls.

---

## 🧪 Testing Strategy
- Factories created for most core models.
- Integration tests simulate full battles.
- Tests validating:
  - Battle setup
  - Character creation limits
  - Equipment enforcement
  - Turn order execution

---

## 📌 Future Ideas
- Matchmaking system
- Character progression + XP
- Reputation/ranking system
- Frontend lobby system
- Skill checks (DEX, STR, INT, etc.)
- Custom item builder (non-magical only for now)

---

## 🔍 Review System
As part of QA and code health, we are now reviewing all models, services, and controllers to ensure they:
- Align with game logic and goals
- Are consistent and DRY
- Are fully covered by tests
- Support upcoming features (like Analyzer and AI strategy)

Uploads are being reviewed piece-by-piece.

---

Let me know if you want to:
- Add/remove features from this plan
- Prioritize anything for front-end API exposure
- Include this overview in GitHub README

