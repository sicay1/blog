---
layout: post
title: "Fixing Common GitHub Actions Errors in Unity CI/CD Builds"
date: 2025-10-04
categories: [unity, github-actions, ci-cd]
thumbnail: /assets/images/posts/github-action.png
excerpt: Learn how to resolve common errors in GitHub Actions workflows for Unity projects.
---

This post builds upon the GitHub Actions setup for Unity builds, addressing common errors that can occur during CI/CD pipelines and providing practical fixes.

## Prerequisites

Before using the workflow, you need to set up the following GitHub secrets in your repository:

### Required Secrets

1. **UNITY_LICENSE** - Your Unity license file content
2. **UNITY_EMAIL** - Email associated with your Unity account
3. **UNITY_PASSWORD** - Password for your Unity account

### Setting up Unity License Secret

#### Option 1: Personal License (Recommended for small projects)
1. Install Unity Hub and Unity Editor (version 6000.1.11f1)
2. Open Terminal/Command Prompt and navigate to Unity installation directory
3. Run the following command to generate license file:
   ```bash
   # On macOS/Linux
   /Applications/Unity/Hub/Editor/6000.1.11f1/Unity.app/Contents/MacOS/Unity -batchmode -quit -logFile /dev/stdout -createManualActivationFile || true
   
   # On Windows
   "C:\Program Files\Unity\Hub\Editor\6000.1.11f1\Editor\Unity.exe" -batchmode -quit -logFile -createManualActivationFile
   ```
4. This creates a `.alf` file in your Unity installation directory
5. Go to https://license.unity3d.com/manual and upload the `.alf` file
6. Download the generated `.ulf` license file
7. Copy the entire content of the `.ulf` file and add it as `UNITY_LICENSE` secret

#### Option 2: Professional License
If you have a Unity Pro license, you can use your Unity ID credentials directly with `UNITY_EMAIL` and `UNITY_PASSWORD`.

### Setting up GitHub Secrets

1. Go to your GitHub repository
2. Click on **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add each secret:
   - Name: `UNITY_LICENSE`, Value: (content of your .ulf file)
   - Name: `UNITY_EMAIL`, Value: (your Unity account email)
   - Name: `UNITY_PASSWORD`, Value: (your Unity account password)

## How to Use the Workflow

### Manual Trigger (workflow_dispatch)

1. Go to your GitHub repository
2. Click on **Actions** tab
3. Select **Build and Release** workflow from the left sidebar
4. Click **Run workflow** button
5. Fill in the required inputs:
   - **Release version**: Enter version number (e.g., v1.0.0, v1.1.0)
   - **Create GitHub Release**: Check this to automatically create a GitHub release
6. Click **Run workflow**

### What the Workflow Does

1. **Checkout**: Downloads your repository code
2. **Git LFS**: Handles large files if you're using Git LFS
3. **Cache**: Caches Unity Library folder to speed up subsequent builds
4. **Build**: 
   - Builds Windows 64-bit standalone executable
   - Builds Android APK
5. **Upload Artifacts**: Stores build files as GitHub artifacts
6. **Create Release** (if enabled):
   - Downloads build artifacts
   - Creates ZIP file for Windows build
   - Renames Android APK
   - Creates GitHub release with downloadable assets

### Build Outputs

- **Windows**: `Game1-Windows-{version}.zip`
- **Android**: `Game1-Android-{version}.apk`

## Workflow Features

- ✅ Manual trigger with custom version input
- ✅ Parallel builds for Windows and Android
- ✅ Automatic artifact caching for faster builds
- ✅ Git LFS support for large assets
- ✅ Automatic GitHub release creation
- ✅ Proper artifact naming with version numbers

## Build Platforms

- **Windows**: StandaloneWindows64 (64-bit Windows executable)
- **Android**: Android APK with ARM64 support

## Customization

You can modify the workflow file (`.github/workflows/build-and-release.yml`) to:
- Add more platforms (iOS, macOS, Linux, WebGL)
- Change build settings
- Add pre/post-build steps
- Modify artifact naming
- Add automated testing

## Troubleshooting

### Common Issues

1. **Unity License Error**: Make sure your license is properly formatted and valid
2. **Build Fails**: Check Unity console logs in the GitHub Actions output
3. **Android Build Issues**: Ensure Android SDK is properly configured in your Unity project
4. **Large Repository**: Consider using Git LFS for large assets to avoid checkout timeouts

## Error: `Docker: failed to register layer: write /opt/unity/Editor/Data/Resources/unity_builtin_extra: no space left on device`

This error occurs when the GitHub runner runs out of disk space during the Unity build process, particularly for Android builds which require more space.

### Check
GitHub runner Ubuntu latest spec link: https://github.com/actions/runner-images
For Private Repositories:
- Operating System: Ubuntu (currently ubuntu-24.04 as the default for ubuntu-latest as of December 5th, 2024, with full rollout completion by January 17th, 2025).
- Processor (CPU): 2 cores
- Memory (RAM): 7 GB
- Storage (SSD): 14 GB
- Architecture: x64

### Fix
Use the free-disk-space action by jbunbroso to clean up disk space before building:

```yml
      - if: matrix.targetPlatform == 'Android'
        uses: jlumbroso/free-disk-space@v1.2.0
```

## Error: `This request has been automatically failed because it uses a deprecated version of actions/upload-artifact: v3.`

GitHub deprecated `actions/upload-artifact` v3 on June 30, 2024.

### Reason
actions/upload-artifact v3 deprecation on June 30, 2024 - link: https://github.blog/changelog/2024-04-16-deprecation-notice-v3-of-the-artifact-actions/
Note: download-artifact@v4+ is not currently supported on GitHub Enterprise Server (GHES) yet. If you are on GHES, you must use v3.

### Fix
Update to v4:

```yml
      - uses: actions/upload-artifact@v4
        with:
          name: my-artifact
          path: path/to/artifact
```

## Error: `the action actions/upload-release-asset@v1 was in archived mode`

The `actions/upload-release-asset@v1` action has been archived.

### Fix
Replace with `softprops/action-gh-release@v2`:

```yml
      - uses: softprops/action-gh-release@v2
        with:
          files: |
            build/Windows/*.zip
            build/Android/*.apk
```

## Using Self-Hosted Runner with Podman

GitHub runners default to installing Docker and GitHub Actions use the docker.io registry. For self-hosted runners on Ubuntu using Podman containers, you need to adapt the workflow to use Podman instead of Docker.

Key changes needed:
- Replace Docker commands with Podman equivalents
- Update container registry references if necessary
- Ensure Podman is properly configured on the self-hosted runner

## Getting Help

If you encounter issues:
1. Check the GitHub Actions logs for detailed error messages
2. Verify all secrets are properly set
3. Ensure your Unity version matches the workflow (6000.1.11f1)
4. Check GameCI documentation: https://game.ci/

## Security Notes

- Never commit Unity license files or credentials to your repository
- Use GitHub secrets for all sensitive information
- Consider using environment-specific secrets for different deployment stages