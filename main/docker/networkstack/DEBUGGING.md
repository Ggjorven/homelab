# Debugging

This file exists with the purpose of helping you debug your issues with `networkstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### Flaresolverr taking very long to start chromium

I have noticed that on some machines flaresolverr takes an insanely long time to boot.

#### Solution A (recommended)

Changing:
```
image: ghcr.io/flaresolverr/flaresolverr:latest
```
To:
```
image: 21hsmw/flaresolverr:nodriver
```
May work, depending on the state of the unofficial fork.

#### Solution B

Changing:
```
image: ghcr.io/flaresolverr/flaresolverr:latest
```
To:
```
image: ghcr.io/flaresolverr/flaresolverr:v3.3.0
```
Or some other older version works sometimes.
Do note, that instead of it taking 5 minutes to boot it can still take like 2,5 minutes. But that falls in the range of what **Prowlarr** allows as the timeout, so far now this is the solution.

Related github issues: [#1318](https://github.com/FlareSolverr/FlareSolverr/issues/1318), [#1610](https://github.com/FlareSolverr/FlareSolverr/issues/1610), [#142](https://github.com/FlareSolverr/FlareSolverr/issues/142), [#687](https://github.com/FlareSolverr/FlareSolverr/issues/687), [#1403](https://github.com/FlareSolverr/FlareSolverr/issues/1403), [#1361](https://github.com/FlareSolverr/FlareSolverr/issues/1361), [#1276](https://github.com/FlareSolverr/FlareSolverr/issues/1276), [#1253](https://github.com/FlareSolverr/FlareSolverr/issues/1253) and [#1501](https://github.com/FlareSolverr/FlareSolverr/discussions/1501)  
Related reddit threads: [1](https://www.reddit.com/r/sonarr/comments/1izl9e6/flaresolverr_broken/), [2](https://www.reddit.com/r/yggTorrents/comments/1iv1fgt/un_fork_de_flaresolverr_fonctionnel_avec_ygg/?tl=en)

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
