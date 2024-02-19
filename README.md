# Task templates

[![Software License](https://img.shields.io/badge/license-MIT-informational.svg?style=flat)](LICENSE)
[![Pipeline Status](https://gitlab.com/op_so/task/task-templates/badges/main/pipeline.svg)](https://gitlab.com/op_so/task/task-templates/pipelines)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

A set of reusable [Task](https://taskfile.dev) templates, ready to use.

## Getting started

### Requirements

To use:

* [Task](https://taskfile.dev)
* `curl` or `wget`
* [Docker](https://docs.docker.com/engine/install/) (recommended): Many templates use Docker images to avoid installing software.

### Structure

* `Taskfile.d`: Directory of the task template files
* `Taskfile.project.yml`: Task file for the project that has the `TASK_TEMPLATES` variable
* `Taskfile.yml`: Core Task file with generic tasks, don't edit it!

### Installation

* Download the main `Taskfile.yml` and the project file template `Taskfile.project.yml`:

with `curl`:

```shell
curl --progress-bar -o Taskfile.yml https://gitlab.com/op_so/task/task-templates/-/raw/main/Taskfile.dist.yml
```

```shell
curl --progress-bar -o Taskfile.project.yml https://gitlab.com/op_so/task/task-templates/-/raw/main/Taskfile.project.dist.yml
```

or with `wget`:

```shell
wget -cq --show-progress -O Taskfile.yml https://gitlab.com/op_so/task/task-templates/-/raw/main/Taskfile.dist.yml
```

```shell
wget -cq --show-progress -O Taskfile.project.yml https://gitlab.com/op_so/task/task-templates/-/raw/main/Taskfile.project.dist.yml
```

On Alpine Linux, `--show-progress` option isn't available.

* Select your templates by editing the `Taskfile.project.yml` file variable `TASK_TEMPLATES`:

example:

```yaml
vars:
  TASK_TEMPLATES: go,lint
```

and run:

```shell
task install-templates
```

A specific version of a template can be specify as follow:

example for go:

```yaml
vars:
  TASK_TEMPLATES: go[1.7.3],lint
```

* Git:

`Taskfile.project.yml` is the file that has your specific project tasks. You should probably commit it.
If you always want the last version of the task templates, add this following line in your `.gitignore` file

```shell
/Taskfile.d/
```

Otherwise, if you prefer stability you should also commit the content of the `Taskfile.d` directory or specify the versions of the templates.

* `task` command without any parameter shows the available installed tasks:
![Available tasks](tasks-list.png "Available tasks")

## Available templates

* `age.yml`: Encrypt/Decrypt with [`age`](https://github.com/FiloSottile/age)
* `ansible.yml`: `Ansible` common tasks
* `crypto.yml`: Cryptographic tasks, generate keys, certificates
* `docker.yml`: `Docker` common tasks
* `git.yml`: `Git` signed commit and [`commitizen`](http://commitizen.github.io/cz-cli/) tasks
* `go.yml`: `Go` task
* `lint.yml`: General lint text files tasks for every project
* `multipass.yml`: [`Multipass`](https://multipass.run/) tasks
* `python.yml`: Python tasks
* `robot.yml`: [Robot Framework](https://robotframework.org/) useful tasks
* `sbom.yml`: Software bill of materials (`SBOM`) commands with [`syft`](https://github.com/anchore/syft) and [`cosign`](https://github.com/sigstore/cosign)
* `system.yml`: System interaction
* `version.yml`: Useful version tasks like get last version on `Github`, `pypi`
* `yarn.yml`: `Yarn` tasks

### Upgrade

* To upgrade your existing templates, just run the command: `task install-templates`,
* To add a new template, add it to the variable `TASK_TEMPLATES` and run `task install-templates`.

## Authors

<!-- vale off -->
* **FX Soubirou** - *Initial work* - [GitLab repositories](https://gitlab.com/op_so)
<!-- vale on -->

## License

<!-- vale off -->
This program is free software: you can redistribute it and/or modify it under the terms of the MIT License (MIT). See the [LICENSE](https://opensource.org/licenses/MIT) for details.
<!-- vale on -->
