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



### ios to_fir_debug_full

```sh
[bundle exec] fastlane ios to_fir_debug_full
```



### ios to_fir_release

```sh
[bundle exec] fastlane ios to_fir_release
```



### ios to_fir_release_full

```sh
[bundle exec] fastlane ios to_fir_release_full
```



### ios build

```sh
[bundle exec] fastlane ios build
```



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

### ios comit_git

```sh
[bundle exec] fastlane ios comit_git
```

添加git commit

### ios push_to_remove

```sh
[bundle exec] fastlane ios push_to_remove
```

Push to remote branch

### ios push_git

```sh
[bundle exec] fastlane ios push_git
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
