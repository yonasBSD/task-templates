# Task Templates

[![Software License](https://img.shields.io/badge/license-GPL%20v3-informational.svg?style=flat&logo=gnu)](LICENSE)
[![Pipeline Status](https://gitlab.com/op_so/task/task-templates/badges/main/pipeline.svg)](https://gitlab.com/op_so/task/task-templates/pipelines)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

A set of reusable [Task](https://taskfile.dev) templates, ready to use.

## Getting Started

### Prerequisities

In order to use:

* [Task](https://taskfile.dev)
* curl
* [Docker](https://docs.docker.com/engine/install/) (recommended): Many templates use Docker images to avoid the need to install any software.

### Installation

* Download the main Taskfile.yml:

```shell
curl --progress-bar -o Taskfile.yml https://gitlab.com/op_so/task/task-templates/-/raw/main/Taskfile.dist.yml
```

* Select your template(s)

```shell
t 01-t-activate T=lint,yarn
```

Or manual installation: edit the Taskfile.yml file and uncomment in the `include:` section the template(s) to use and the `01-download:` section of the template(s) to download.

* Download resources:

```shell
task 01-download
```

* [Optional] Create a dedicated taskfile for your project:

Uncomment the two lines in the `Taskfile.yml`

```shell
# 00:
#   taskfile: "./Taskfile.project.yml"
```

Create a file `Taskfile.project.yml`

## Authors

* **FX Soubirou** - *Initial work* - [Gitlab repositories](https://gitlab.com/op_so)

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) file for details.
