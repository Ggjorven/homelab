# Debugging

This file exists with the purpose of helping you debug your issues with `networkstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### Flaresolverr taking very long to start chromium

I have noticed that on some machines flaresolverr takes an insanely long time to boot.

Changing:
```
image: ghcr.io/flaresolverr/flaresolverr:latest
```
To:
```
image: ghcr.io/flaresolverr/flaresolverr:v3.4.5
```
Or some other older version.

Related github issues: [#1318](https://github.com/FlareSolverr/FlareSolverr/issues/1318) and [#1610](https://github.com/FlareSolverr/FlareSolverr/issues/1610)

Do note, that instead of it taking 5 minutes to boot it can still take like 2,5 minutes. But that falls in the range of what **Prowlarr** allows as the timeout, so far now this is the solution.

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
