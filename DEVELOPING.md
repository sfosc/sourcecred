# Developing

This document contains details on how `sfosc.org/sourcecred` is configured, tested and deployed.
You might be interested in these procedures if you are interested in development of the site.

Brief overview:
- Hosting: [GitHub pages](https://pages.github.com/)
- Build automation: [drone.io](https://drone.io/), self-hosted instance at https://drone.sfosc.robin-it.com
- SourceCred scoring and pages: [SourceCred](https://sourcecred.io/)

## Testing

You will need to have your `~/.ssh/id_rsa` set up to be able to connect to GitHub.
All repositories accessed are public so you only require read access.

Also store a [Personal Access Token](https://github.com/settings/tokens) in `./secrets/token`.
No special scope access required.

Make sure you've checked out the submodule:

```sh
git submodule init
git submodule update
```

Then run `./scripts/local-debug.sh`, to load the scores and render a preview at localhost.
Requires `node` (v10 or v12) and `yarn` to be installed.

## Note on CI

We're using a self-hosted [Drone.io](https://drone.io) instance to support cronjobs (see [comment](https://discourse.drone.io/t/cron-on-cloud-drone-io/3899)).

Build history will display under
https://drone.sfosc.robin-it.com/sfosc/sourcecred

### Helper account

To run CI jobs, you'll likely want a Github helper account.
This way you can run SourceCred with unprivileged (read-only) access to the repositories you are analysing.

In this instance the account used is https://github.com/beanow-credhelper

For this account you should generate an SSH keypair (`ssh-keygen -f credhelper`).
And set it's public key here https://github.com/settings/keys
And the private key as a Drone secret `SSH_BOT_KEY`.

Next you'll want a [Personal Access Token](https://github.com/settings/tokens) from this helper account as well.
And set it as a Drone secret `SOURCECRED_GITHUB_TOKEN`.

### Deploy key

The one secret that does have write access is the [deploy key](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys)
configured as a drone secret `SSH_DEPLOY_KEY`.

This secret needs to hold the _private key_ part, and should be RSA only.
The public part of the key is configured at https://github.com/sfosc/sourcecred/settings/keys.

You can generate a new RSA keypair using `ssh-keygen -f deploy-key`.

### Caching

For caching we currently cache:

- `./sourcecred_data/cache`
- `./sourcecred/node_modules`
- `./widgets/node_modules`

The sourcecred data cache stores information we would retrieve from the GitHub API and saves a lot of calls there
as you don't need to download the entire history of your repositories again, only changes since the last run.
The node_modules speed up yarn installs. Particularly the `better-sqlite3` dependency, which compiles from source
with node-gyp and takes several minutes to do so.

The current Drone configuration also uses ["host volumes"](https://docker-runner.docs.drone.io/configuration/volumes/host/)
for this. This is only available when you self-host a Drone instance because:

>  This setting is only available to trusted repositories, since mounting host machine volumes is a security risk.

In a different environment you may need to adjust the configuration to use a different storage backend instead.
For example AWS S3, which is supported by the caching plugin used: [meltwater/drone-cache](https://github.com/meltwater/drone-cache/blob/master/docs/examples/drone-1.0.md).
