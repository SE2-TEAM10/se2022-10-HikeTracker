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
  - Estimated Average: 74.75 / 22 = 3.4 = 3h 24m
  - Estimated Stardard deviation: 10.18 = 10h 11m
  - Actual: 60.75 / 22 = 2.75 = 2h 45m
  - Actual Stardard deviation: 7.76 = 7h 46m
- Total task estimation error ratio: sum of total hours estimation / sum of total hours spent - 1
  - (74.75 / 60.75) - 1 = 0.23
  
## QUALITY MEASURES 

- Unit Testing:
  - Total hours estimated
    - 2h 30m
  - Total hours spent
    - 4h
  - Nr of automated unit test cases
    - 19
  - Coverage (if available)
    - 68%
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
  - 
- What lessons did you learn (both positive and negative) in this sprint?

- Which improvement goals set in the previous retrospective were you able to achieve? 
  
- Which ones you were not able to achieve? Why?

- Improvement goals for the next sprint and how to achieve them (technical tasks, team coordination, etc.)

> Propose one or two

- One thing you are proud of as a Team!!