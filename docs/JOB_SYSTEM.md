# Prison job system

The prison uses a hybrid system: a character may apply for an available job by speaking with the work-office staff, or receive an automatic assignment when a new day begins and no job is active.

## Available jobs

| Job | Daily tasks | Bread reward | Work credits |
|---|---:|---:|---:|
| Kitchen worker | 3 | 2 | 5 |
| Laundry worker | 3 | 1 | 6 |
| Library assistant | 2 | 1 | 7 |
| Workshop worker | 2 | 1 | 8 |
| Gardener | 3 | 2 | 5 |

## Daily loop

1. Visit the work office to view the job board and apply, or wait for the daily automatic assignment.
2. Visit the appropriate work area and complete simple, non-hazardous minigame tasks.
3. Completing all tasks for the shift awards the job's bread and work credits.
4. Job experience increases the player's rank: Unassigned, Beginner, Regular, then Trusted.
5. A new day resets task progress. If the player has no active job, the system selects an available job automatically.

## Character interactions

- Work-office staff explain available jobs and accept applications.
- Coworkers provide short dialogue and optional story moments.
- Completing a shift can unlock new dialogue and small narrative opportunities.
- Job tasks should be approachable VR interactions such as sorting, serving, shelving, repairing harmless objects, and watering plants.

## Implementation

The initial logic lives in `scripts/job_system.gd`. It exposes signals for job changes, task progress, completion, and messages. The game scene can connect `job_completed` to the food system's `collect(bread_reward)` method and display work credits in the HUD.
