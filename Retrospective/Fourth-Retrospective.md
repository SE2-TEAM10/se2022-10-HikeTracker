TEMPLATE FOR RETROSPECTIVE (Team 10)
=====================================

The retrospective should include _at least_ the following
sections:

- [process measures](#process-measures)
- [quality measures](#quality-measures)
- [general assessment](#assessment)

## PROCESS MEASURES

### Macro statistics

- Number of stories committed vs done
  - Commited 7 vs Done 7
- Total points committed vs done
  - Commmited 47 vs Done 47
- Nr of hours planned vs spent (as a team)
  - Planned 55 vs Spent 56

**Remember**  a story is done ONLY if it fits the Definition of Done:

- Unit Tests passing
- Code review completed
- Code present on VCS
- End-to-End tests performed

> Please refine your DoD

### Detailed statistics

| Story | # Tasks | Points | Hours est. | Hours actual |
| ----- | ------- | ------ | ---------- | ------------ |
| _#0_  | 8       | -      | 15h        | 13h          |
| _#17_ | 4       | 13     | 2h 30m     | 3h 30m       |
| _#18_ | 4       | 8      | 3h         | 3h           |
| _#34_ | 4       | 2      | 4h         | 4h 30m       |
| _#8_  | 4       | 8      | 7h 30m     | 7h           |
| _#9_  | 7       | 3      | 9h 45m     | 11h 15m      |
| _#33_ | 5       | 5      | 7h         | 6h           |
| _#19_ | 6       | 8      | 6h 15m     | 7h 45m       |

> place technical tasks corresponding to story `#0` and leave out story points (not applicable in this case)

- Hours per task average, standard deviation (estimate and actual)
  - Estimated Average: 55 / 42 = 1h 19m
  - Estimated Stardard deviation: 3.832 = 3h 50m
  - Actual: 56 / 42 = 1h 20m
  - Actual Stardard deviation: 3.356 = 3h 21m
- Total task estimation error ratio: sum of total hours estimation / sum of total hours spent - 1
  - (55 / 56) - 1 = 0.982 - 1 = -0.018
  
## QUALITY MEASURES

- Unit Testing:
  - Total hours estimated
    - 7h
  - Total hours spent
    - 6h 30m
  - Nr of automated unit test cases
    - 54
  - Coverage (if available)
    - 68%
- E2E testing:

- Total hours estimated
  - 30m

- Total hours spent
  - 30m

- Code review

- Total hours estimated
  - 30m

- Total hours spent
  - 30m

- Technical Debt management:

- Total hours estimated
  - 3h 30m

- Total hours spent
  - 3h 30m

- Hours estimated for by SonarQube
  - 4h

  - Hours estimated for remediation by SonarQube only for the selected and planned issues
    - 3h 30m

- Hours spent on remediation
  - 3h 30m

- debt ratio (as reported by SonarQube under "Measures-Maintainability")
  - 0.1%

  - rating for each quality characteristic reported in SonarQube under "Measures" (namely reliability, security, maintainability )
    - Reliability : A
    - Security: A
    - Maintainability: A

## ASSESSMENT

- What caused your errors in estimation (if any)?
  - One of the story inserted in the sprint had already some work done from the previous sprint.
  - One of our team member left the team during the sprint

- What lessons did you learn (both positive and negative) in this sprint?
  - We tried to develop in a more efficent and collaborive way, and we did it, that lead to a better way of managing the repository

- Which improvement goals set in the previous retrospective were you able to achieve?
  - We wrote a task for each issue present in SonarQube and we were able to track and manage the issues

- Which ones you were not able to achieve? Why?
  - We achieved every goal set in previous retrospective

- Improvement goals for the next sprint and how to achieve them (technical tasks, team coordination, etc.)
  - Look for a way to handle the stories that are left in between the two sprints

> Propose one or two

- One thing you are proud of as a Team!!
  - Team working and communication were fine.
