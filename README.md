# setup_ubuntu

Shell scripts to set up a development environment on **Ubuntu 24.04 LTS**.

## How to use

### 1. Full system setup (recommended)

From the repo root:

```bash
cd setup_ubuntu
./setting_ubuntu24.04.sh
```

This runs `update_ubuntu.sh` and then executes the full install pipeline
in `ubuntu24.04/setup_programs/total_install_programs.sh`. A timestamped
log is written to `ubuntu24.04/setup_programs/log/`.

The first step (`setup_dualboot.sh`) is interactive and asks whether
you are dual-booting with Windows. To skip it non-interactively:

```bash
DUALBOOT_SKIP=1 ./setting_ubuntu24.04.sh
```

Reboot when the script finishes (required for NVIDIA driver, Docker
group membership, and Conda shell init to take effect).

### 2. ROS 2 Jazzy (Desktop-Full)

```bash
cd setup_ubuntu/ubuntu24.04/ROS2_jazzy
./install_ROS2_jazzy_full.sh
```

Creates a workspace at `~/robot_workspace/robot_ws`, installs Cyclone DDS,
and appends ROS 2 environment + aliases to `~/.bashrc`.

## What gets installed

Run individually from `ubuntu24.04/setup_programs/` or all at once via
`total_install_programs.sh`:

| Script | Installs |
| --- | --- |
| `setup_dualboot.sh` | Windows-compatible RTC, GRUB saved-default |
| `uninstall_firefox.sh` | Removes default Firefox snap |
| `install_curl.sh` | curl |
| `install_git.sh` | git |
| `install_github_cli.sh` | GitHub CLI (`gh`) |
| `install_build-essential.sh` | gcc / g++ / make |
| `install_cmake_ninja.sh` | CMake + Ninja |
| `install_clang.sh` | Clang 18 + clang-format / clang-tidy |
| `install_python.sh` | Python 3 + pip + venv (PEP 668-aware) |
| `install_terminal.sh` | terminator, vim, tmux |
| `install_IDE.sh` | VS Code (PyCharm commented out) |
| `install_apps.sh` | Monitoring, graphics, productivity, robotics apps |
| `install_conda.sh` | Miniforge (mamba) on conda-forge only |
| `setup_bashrc.sh` | Git-branch prompt, RTC in local time |
| `install_nvidia_driver.sh` | Recommended proprietary NVIDIA driver |
| `install_docker.sh` | Docker Engine + NVIDIA Container Toolkit |

## Logs

`total_install_programs.sh` writes a full transcript to
`ubuntu24.04/setup_programs/log/setup_YYYYMMDD_HHMMSS.log`. The `log/`
directory is gitignored.
