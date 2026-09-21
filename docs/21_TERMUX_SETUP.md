# Termux + Gemini CLI Setup

## 1. Install prerequisites

Gemini CLI currently requires Node.js 20+ and an internet connection. On Termux, install a supported Node.js package available to your environment, then verify:

```bash
node --version
npm --version
```

## 2. Install Gemini CLI

```bash
npm install -g @google/gemini-cli
gemini --version
```

## 3. Unzip PlayTv

```bash
unzip PlayTv-Gemini.zip
cd PlayTv
```

## 4. Start Gemini

```bash
gemini
```

The first session should be used to inspect the project and documentation before implementation.

## 5. Recommended first prompt

```text
Read GEMINI.md and every document under docs/. Inspect the current Flutter codebase, backend integration points, and GitHub workflows. Do not modify anything yet. Produce a detailed implementation audit showing what is implemented, what is incomplete, what must be corrected, and the exact order you recommend for implementation. Treat the docs as requirements and the existing code as the current state. Wait for my approval before making changes.
```

## 6. Normal development loop

```bash
git status
gemini
# ask Gemini to implement one coherent phase
git diff
flutter analyze
flutter test
git status
git add .
git commit -m "feat: ..."
git push
```

GitHub Actions then performs the reproducible CI/build checks.
