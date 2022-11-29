TEMPLATE FOR RETROSPECTIVE (Team 10)
=====================================

The retrospective should include _at least_ the following
sections:

- [process measures](#process-measures)
- [quality measures](#quality-measures)
- [general assessment](#assessment)

## PROCESS MEASURES

### Macro statistics

- Number of stories committed vs. done
  - Commited 5 vs Done 3
- Total points committed vs. done
  - Commmited 15 vs Done 11
- Nr of hours planned vs. spent (as a team)
  - Planned 72h vs Spent 60h

**Remember** a story is done ONLY if it fits the Definition of Done:

- Unit Tests passing
- Code review completed
- Code present on VCS
- End-to-End tests performed

> Please refine your DoD if required (you cannot remove items!)

### Detailed statistics

| Story  | # Tasks | Points | Hours est. | Hours actual |
|--------|---------|--------|------------|--------------|
| _#2_   |    5     |    5   |     29h       |      27 30m        |
| _#3_   |    6     |    3   |      10h 45m      |    13h 15m          |
| _#4_   |    4     |    3   |      6h 30m      |      6h        |
| _#0_   |    7     |    -   |      28h 30m      |      14h        |

> place technical tasks corresponding to story `#0` and leave out story points (not applicable in this case)

- Hours per task average, standard deviation (estimate and actual)
  - Estimated Average: 74.75 / 22 = 3.4 = 3h 24m
  - Estimated Stardard deviation: 10.18 = 10h 11m
  - Actual: 60.75 / 22 = 2.75 = 2h 45m
  - Actual Stardard deviation: 7.76 = 7h 46m
- Total task estimation error ratio: sum of total hours estimation / sum of total hours spent - 1
  - (74.75 / 60.75) - 1 = 0.23

## QUALITY MEASURES

- Unit Testing:
  - Total hours estimated
    - 7h
  - Total hours spent
    - 9h
  - Nr of automated unit test cases
    - 19
  - Coverage (if available)
    - 68%
- E2E testing:
  - Total hours estimated
    - 3h
  - Total hours spent
    - 1h
- Code review
  - Total hours estimated
    - 3h
  - Total hours spent
    - 1h 30m

## ASSESSMENT

- What caused your errors in estimation (if any)?
  - We actually overestimated configurations like the one for Docker
  - We underestimated some frontend tasks

- What lessons did you learn (both positive and negative) in this sprint?
  - We need to improve in estimations precision
  - We have to be more indipendent in assigning tasks

- Which improvement goals set in the previous retrospective were you able to achieve?
  - We were more precise in the estimations and at the end we commited a similar amout of work to the one estimated
  - Our velocity has improved

- Which ones you were not able to achieve? Why?
  - We have improved a lot but we can always do better

- Improvement goals for the next sprint and how to achieve them (technical tasks, team coordination, etc.)
  - We are going to improve in estimations precision
  - We are going to assign tasks in a more indipendent way after consulting with the team

> Propose one or two

- One thing you are proud of as a Team!!
  - Team working and communication were fine ;)
