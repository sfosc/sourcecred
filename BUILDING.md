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

The net effect is, the drone configuration will be taken from
https://github.com/Beanow/sfosc-sourcecred-cron/blob/master/.drone.yml

Build history will display under
https://drone.sfosc.robin-it.com/Beanow/sfosc-sourcecred-cron

Everything else is sourced from and deployed to:
https://github.com/sfosc/sourcecred

This is a workaround until some permission issues can be fixed with the sfosc organization.
