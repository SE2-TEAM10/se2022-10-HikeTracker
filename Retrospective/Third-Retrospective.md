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
  - Commited 4 vs Done 3
- Total points committed vs done 
  - Commmited 17 vs Done 9
- Nr of hours planned vs spent (as a team)
  - Planned 65h 30m vs Spent 51h 45m

**Remember**  a story is done ONLY if it fits the Definition of Done:
 
- Unit Tests passing
- Code review completed
- Code present on VCS
- End-to-End tests performed

> Please refine your DoD 

### Detailed statistics

| Story | # Tasks | Points | Hours est. | Hours actual |
|-------|---------|--------|------------|--------------|
| _#0_  | 7       | -      | 23h 30m    | 22h          |
| _#5_  | 4       | 2      | 12h 30m    | 14h 45m      |
| _#6_  | 4       | 2      | 4h 30m     | 5h           |
| _#7_  | 4       | 5      | 10h 30m    | 6h           |


> place technical tasks corresponding to story `#0` and leave out story points (not applicable in this case)

- Hours per task average, standard deviation (estimate and actual)
  - Estimated Average: 51 / 19 = 2.7 = 2h 42m
  - Estimated Stardard deviation: 6.87 = 6h 52m
  - Actual: 47.75 / 19 = 2.5 = 2h 30m
  - Actual Stardard deviation: 6.93 = 6h 56m
- Total task estimation error ratio: sum of total hours estimation / sum of total hours spent - 1
  - (51 / 47.75) - 1 = 0.06
  
## QUALITY MEASURES 

- Unit Testing:
  - Total hours estimated
    - 2h 30m
  - Total hours spent
    - 4h
  - Nr of automated unit test cases
    - 24
  - Coverage (if available)
    - 72%
- E2E testing:
  - Total hours estimated
    - 1h
  - Total hours spent
    - 45m
- Code review
  - Total hours estimated
    - 1h 30m
  - Total hours spent
    - 1h
- Technical Debt management:
  - Total hours estimated
    - 4h
  - Total hours spent
    - 2h
  - Hours estimated for by SonarQube
    - 4h
  - Hours estimated for remediation by SonarQube only for the selected and planned issues 
  - Hours spent on remediation
    - 2h
  - debt ratio (as reported by SonarQube under "Measures-Maintainability")
    - 0.1%
  - rating for each quality characteristic reported in SonarQube under "Measures" (namely reliability, security, maintainability )
    - Reliability : A
    - Security: A
    - Maintainability: A


## ASSESSMENT

- What caused your errors in estimation (if any)?
  - We didn't estimate in detail the tasks about SonarQube, so in the retrospective there is a general estimation.
- What lessons did you learn (both positive and negative) in this sprint?
  - The collaboration between the team members that worked on the front-end and the ones that worked on the back-end has improved significantly in this sprint.
- Which improvement goals set in the previous retrospective were you able to achieve? 
  - We estimated more hours for the front-end tasks, since it was the main problem in the precious sprint
- Which ones you were not able to achieve? Why?
  - We made some improvements, but we can always do better
- Improvement goals for the next sprint and how to achieve them (technical tasks, team coordination, etc.)
  - We need to write a task for each issue present in SonarQube
> Propose one or two

- One thing you are proud of as a Team!!
  - Team working and communication were fine.