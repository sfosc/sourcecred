# SFOSC SourceCred cronjob

[![Build Status](https://drone.sfosc.robin-it.com/api/badges/sfosc/sourcecred/status.svg)](https://drone.sfosc.robin-it.com/sfosc/sourcecred)
[![SourceCred prototype](https://badgen.net/badge/SourceCred/prototype)](https://sfosc.org/sourcecred/prototype/)

Early prototype analyzing SourceCred for SFOSC repositories.

Currently looks at:

- https://github.com/sfosc (the full organization, using the `@sfosc` project spec)
- https://github.com/sfosc/sfosc
- https://github.com/sfosc/wizard
- https://github.com/sfosc/sourcecred

## Weight configuration

You can tinker with weight settings within the prototype using "Show weight configuration".
![Show weight configuration](https://user-images.githubusercontent.com/1400023/58102973-d9506880-7bea-11e9-836f-71d9a6768ab4.png)

The default values for this can be changed in a config file: [`weights.toml`](./weights.toml).

You're welcome to submit a pull request for this file if you believe we should distribute cred differently.
Be sure to include an explanation why you think it should be changed.
