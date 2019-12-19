# vsoch r-universe

This is a development repository to figure out how to reproduce the functionality
of [r-universe/ropensci](https://github.com/r-universe/ropensci), but completely
using GitHub workflows.

## Plan of Action

The steps that I want to take are the following:

### 1. Submodule Updates

Currently, in the [r-universe/ropensci](https://github.com/r-universe/ropensci) repository,
it's required that a Jenkins server update submodules. However since dependabot was
acquired by GitHub and offers a [free service](https://dependabot.com/submodules/) to do this 
via pull request, I think we can try this out.

### 2. Pull Request

When a submodule is updated, this will trigger a pull request to the repository.
Normally this would need review by a person, however we would have a GitHub action
workflow to instead handle it.

### 3. GitHub Workflows

The pull request workflow would do some validation for the submodule, and then
do build staging. I will think more about this when I'm developing the workflows.
The builds should happen with GitHub actions, and deploy to the package server.

**under development**
