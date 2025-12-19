# How to Publish `voice_note_recorder_player` to pub.dev

Here is a clear step-by-step guide to publishing this package.

## Prerequisites

1.  **Google Account**: You need a Google account to sign in to pub.dev.
2.  **Verified Publisher (Optional)**: If you want to publish under a verified publisher (like a company namespace), you need to set that up on pub.dev.

## Step 1: Preparation

1.  **Review `pubspec.yaml`**:
    *   Ensure the `homepage` or `repository` field is set to a valid URL (e.g., your GitHub repo).
    *   Ensure the `description` is accurate and between 60-180 characters.
    *   Check `version` is correct (e.g., `0.0.1`).
    
    ```yaml
    name: voice_note_recorder_player
    description: A comprehensive Flutter package for recording and playing voice notes with a modern UI.
    version: 0.0.1
    homepage: https://github.com/yourusername/voice_note_recorder_player
    ```

2.  **Update `CHANGELOG.md`**:
    *   Create a `CHANGELOG.md` file in the root if it doesn't exist.
    *   Add an entry for the initial version.

    ```markdown
    ## 0.0.1
    * Initial release.
    ```

3.  **Include `LICENSE`**:
    *   Ensure you have a `LICENSE` file (e.g., MIT, Apache 2.0).

4.  **Format and Analyze**:
    *   Run formatting to ensure code style compliance:
        ```bash
        flutter format .
        ```
    *   Run analysis to check for errors/warnings:
        ```bash
        flutter analyze
        ```
        *Fix any errors or warnings before proceeding.*

## Step 2: Dry Run

Before actually publishing, run a dry run to see if everything is valid.

```bash
flutter pub publish --dry-run
```

This command will check your package validation and show you what files will be uploaded.

**Common Warnings:**
*   "Homepage URL is invalid" -> Add a valid URL in `pubspec.yaml`.
*   "Missing LICENSE" -> Add a LICENSE file.

## Step 3: Publish

Once the dry run passes successfully:

1.  Run the publish command:
    ```bash
    flutter pub publish
    ```

2.  **Authentication**:
    *   The terminal will provide a URL to authenticate with your Google account.
    *   Click the link, sign in, and approve the access.

3.  **Confirmation**:
    *   Once authenticated, the upload will begin.
    *   Wait for the "Successfully uploaded package..." message.

## Step 4: Verification

1.  Go to [pub.dev](https://pub.dev).
2.  Search for `voice_note_recorder_player`.
3.  You should see your package listed!

---

**Tips:**
*   **Documentation**: Make sure your `README.md` is detailed (it's already set up nicely!).
*   **Screenshots**: Add screenshots to the `screenshots/` folder and link them in the README for better engagement.
*   **Example**: The `example/` folder included will be shown in the "Example" tab on pub.dev automatically.

Good luck! 🚀
