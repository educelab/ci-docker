# EduceLab Docker CI Configuration

This repository contains the Dockerfile to build the `ghcr.io/educelab/ci-docker`
[Docker image](https://github.com/orgs/educelab/packages/container/package/ci-docker). This image contains all prerequisite libraries required
to build and test the
[volume-cartographer](https://github.com/educelab/volume-cartographer)
project. Most of the build is handled by
[vc-deps](https://github.com/educelab/vc-deps) so that consistency can be
maintained across platforms.

## Requirements
 * Docker engine 19.03+

## Building
1. Get the source code for the repository:
   ```shell
    git clone --recursive https://github.com/educelab/ci-docker
    cd ci-docker
   ```

2. Update the version number, packages, and code references. See 
   [Updating the version](#updating-the-version).

3. If your changes don't affect the base image, pull the 
latest base image from the registry to avoid rebuilding it:
   ```shell
   docker pull ghcr.io/educelab/ci-docker:base.latest
   ```

4. Set up a multi-arch Docker builder and run the build script:
   ```shell
   docker buildx create --use
   ./build.sh
   ```

## Updating the version
Change the version components in [build.sh](build.sh). Values should match the rules 
for [semantic versioning](https://semver.org/):

```bash
# build.sh
VER_MAJOR=12
VER_MINOR=0
VER_PATCH=0
```

### Version rules
#### Updating the Debian version
- Set `VER_MAJOR` to the Debian version number
- Set `VER_MINOR=0`
- Set `VER_PATCH=0`

#### Adding/removing apt packages
- Increment `VER_MINOR`
- Set `VER_PATCH=0`

#### Updating the apt packages (i.e. rebuilding without adding/removing packages)
- Remove your local copy of `ci-docker:base.latest`
- Increment `VER_PATCH`

#### Updating the installed Qt version
- Increment `VER_MINOR`
- Set `VER_PATCH=0`

#### Updating vc-deps to a new minor version
- Checkout the appropriate ref in the vc-deps directory
- Increment `VER_MINOR`
- Set `VER_PATCH=0`

#### Updating vc-deps to a new patch version
- Checkout the appropriate ref in the vc-deps directory
- Increment `VER_PATCH`