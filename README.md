# SFOSC SourceCred cronjob

[![Build Status](https://drone.sfosc.robin-it.com/api/badges/Beanow/sfosc-sourcecred-cron/status.svg)](https://drone.sfosc.robin-it.com/Beanow/sfosc-sourcecred-cron)
[![SourceCred prototype](https://badgen.net/badge/SourceCred/prototype)](https://beanow.github.io/sfosc-sourcecred-cron/prototype/)

Early prototype using analyzing SourceCred for SFOSC repositories.

Currently looks at:

- https://github.com/sfosc/sfosc
- https://github.com/sfosc/wizard

## Weight configuration

You can tinker with weight settings within the prototype using "Show weight configuration".
![Show weight configuration](https://user-images.githubusercontent.com/1400023/58102973-d9506880-7bea-11e9-836f-71d9a6768ab4.png)

The default values for this can be changed in a config file: [`weights.toml`](./weights.toml).

You're welcome to submit a pull request for this file if you believe we should distribute cred differently.
Be sure to include an explanation why you think it should be changed.

## Testing

You will need to have your `~/.ssh/id_rsa` set up to be able to connect to GitHub.

Also store a [Personal Access Token](https://github.com/settings/tokens) in `./secrets/token`.

Make sure you've checked out the submodule:

```sh
git submodule init
git submodule update
```

Then run `./scripts/local-debug.sh`.

## Note on CI

Currently we're using a workaround to trigger builds.

1. We're using a self-hosted [Drone.io](https://drone.io) instance to support cronjobs.
2. The repository it connects to is https://github.com/Beanow/sfosc-sourcecred-cron.
