# ML development environment

A machine learning development environment with Docker that supports NVIDIA GPU access.

The container user id and group id can be customized. Use the target "build_torch" (for TensorFlow) or "build_tf" (for PyTorch) to build an image so that its container user has the same "uid" and "gid" as the host user.

## How to build
To build an dev env using PyTorch:
```bash
make build_torch
```

To build an dev env using TensorFlow:
```bash
make build_tf
```

## How to start a container
For example, to start a container using PyTorch, run the following command:
```bash
make start_torch project_folder=<your-project-folder>
```
The project folder will be mapped to `/home/devuser/workspace` inside the container.
