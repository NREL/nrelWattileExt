Docker Image for nrelWattileExt
===============================

**Temporary:** These instructions for building the docker image assume that you
have local copies of the [Wattile] and [nrelWattileExt] side-by-side, like this:

- `nrelWattileExt` (this repository)
  - `docker` (the location of this README file)
- `wattile` (Wattile repo)

Once [Wattile] is a published package (or the Github repo is public), the
Dockerfile will change and a local copy of Wattile won't be required.

[Wattile]: https://github.com/NREL/Wattile/ "Wattile"
[nrelWattileExt] https://github.com/NREL/intelligentcampus-model-deploy "TO DO: change this URL"

Instructions
------------

1. Ensure your local environment has a valid copy of the Wattile repo in the
   relative path shown above
2. Launch Docker (if it isn't already running)
3. Open a command prompt in the current directory (location of this README)
4. Execute `docker build --tag wattile --file ./Dockerfile PATH`, where `PATH`
   is the path to the Wattile repo (`../../wattile/` if your repos are organized
   as shown above)