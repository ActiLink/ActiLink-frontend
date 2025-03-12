# ActiLink-frontend

## Getting Started

This project uses Melos for managing. To get started:

```
$ dart pub global activate melos
```

Once Melos is installed, you can bootstrap the project by running:

```
$ melos bootstrap
```

This will install all dependencies and link local packages together.

## Workflow

To run the app in `[development, staging, production]` environment:

```
$ melos run [dev, stage, prod]
```

## Clean

To clean the project (removes all build artifacts and cached packages):

```
$ melos clean
```

## Troubleshooting

If you can't run `melos` from the terminal and the error is something along the lines of "command not found", make sure that you've added appropriate directories to PATH:

* on Unix-like systems, add `$HOME/.pub-cache/bin`
* on Windows, add `%USERPROFILE%\AppData\Local\Pub\Cache\bin`
