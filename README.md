# Dockerized Xfce Desktop with TightVNC on Ubuntu 24.04

## Overview
This Docker image provides a lightweight, containerized Xfce desktop environment, pre-configured for seamless remote access using TightVNC. It is built on the reliable Ubuntu 24.04 base image, offering graphical application support and simplified system management in a secure and user-friendly manner.

---

## Features
- **Base Operating System**: Ubuntu 24.04, ensuring a robust and secure foundation.
- **Desktop Environment**: Xfce4, providing a lightweight yet full-featured graphical interface.
- **VNC Server**: TightVNC, enabling secure and efficient remote desktop connections.
- **Customizable Settings**:
  - **Resolution**: Adjustable VNC geometry for optimal viewing (default: `680x820`).
  - **Port Configuration**:
    - **VNC Port**: `5901`
  - **Password Protection**: Configurable `VNC_PASSWORD` environment variable for enhanced security.
- **Additional Enhancements**:
  - Includes essential fonts and utilities for graphical application compatibility.
  - Automated configuration scripts for simplified deployment.

---

## Environment Variables
The following environment variables can be used to customize the container:

- **`VNC_PASSWORD`**: Sets the root password for VNC and ssh access.
  - **Default**: `password`
- **`VNC_RESOLUTION`**: Defines the screen resolution for the VNC server.
  - **Default**: `680x820`

---

## Getting Started

### Prerequisites
Ensure that you have Docker installed and properly configured on your system.

### Building the Image
To build the Docker image, run the following command:
```bash
docker build -t ubuntu-xfce-vnc . --no-cache
```

### Running the Container
Launch the container using the following command:
```bash
docker run -d --name Ubuntu \
  -p 5901:5901 \
  -e VNC_PASSWORD=password \
  -e VNC_RESOLUTION=1600x900 \
  ubuntu-xfce-vnc
```

### Accessing the Desktop
1. **VNC Client**: Connect to the VNC server at `localhost:5901` using any VNC viewer.

---

## File Structure
```plaintext
.
├── Dockerfile          # Builds the Ubuntu-based Docker image.
├── entrypoint.sh       # Initializes the VNC server and configures the desktop environment.
├── run.sh              # Script to launch the Docker container.
└── README.md           # Documentation for the project.
```

---

## Detailed Explanation of Files

### `Dockerfile`
Contains instructions to:
- Install essential packages (e.g., Xfce, TightVNC).
- Configure the environment and clean up to reduce the image size.

### `entrypoint.sh`
Handles:
- Setting up the VNC password and screen resolution.
- Initializing Xfce and launching the VNC server.
- Starting noVNC for browser-based access.

### `run.sh`
Simplifies the process of starting the container with required configurations.

---

## Security Considerations
- **Password Management**: Always use a strong, unique password for `VNC_PASSWORD`.
- **Port Exposure**: Limit the exposed ports (`5901`, `6080`) to your local network or secure them with firewalls.
- **Updates**: Regularly rebuild the Docker image to ensure you have the latest security patches.

---

## Troubleshooting
### Common Issues:
1. **Black Screen on VNC Connection**:
   - Ensure Xfce is correctly installed and configured.
   - Check the logs using `docker logs <container_id>`.
2. **Browser Connection Errors**:
   - Verify that noVNC is running and accessible at `http://localhost:6080`.
   - Check for port conflicts.

Fork from: https://github.com/techroy23/Docker-Ubuntu-XFCE-VNC
Thanks to techroy23
