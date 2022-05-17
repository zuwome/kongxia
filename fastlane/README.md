fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios to_itunes

```sh
[bundle exec] fastlane ios to_itunes
```



### ios to_fir

```sh
[bundle exec] fastlane ios to_fir
```



### ios to_fir_debug

```sh
[bundle exec] fastlane ios to_fir_debug
```



### ios to_fir_release

```sh
[bundle exec] fastlane ios to_fir_release
```



### ios build

```sh
[bundle exec] fastlane ios build
```

打包

### ios upload

```sh
[bundle exec] fastlane ios upload
```

上传到iTunes

### ios fir

```sh
[bundle exec] fastlane ios fir
```

上传ipa到fir.im服务器

### ios increment_build_num

```sh
[bundle exec] fastlane ios increment_build_num
```

更新build版本号

### ios git_commit_local

```sh
[bundle exec] fastlane ios git_commit_local
```

添加git commit

### ios git_push_to_current

```sh
[bundle exec] fastlane ios git_push_to_current
```

推送到当前分支

### ios git_push_to_remote

```sh
[bundle exec] fastlane ios git_push_to_remote
```

推送分支到远程

### ios notifyMessage

```sh
[bundle exec] fastlane ios notifyMessage
```

mac 推送消息

### ios test

```sh
[bundle exec] fastlane ios test
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
