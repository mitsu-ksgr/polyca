polyca css
==========

polyca css is css framework for little work.

- classless based css framework
  - css class is almost never used, it is only used for theme.
- simple style.
- easy to switch themes.
- easy to make new theme.

check [detail](www.ksgr.net/polyca/).

## development

use [yarn](https://yarnpkg.com/)

```sh
$ git clone https://github.com/mitsu-ksgr/polyca.git
$ cd polyca

# Install packages.
$ yarn

# build scss
$ yarn compile

# minify
$ yarn minify

# build & minify
$ yarn build

# auto build (does not minify)
$ yarn watch
```

### Create new theme

1. create theme filr

```sh
# Use helper script
$ ./jig/new_theme.sh YOUR_THEME_NAME
New theme file created! ./themes/YOUR_THEME_NAME.scss

# or copy already existing theme file
$ cp ./themes/dark.scss ./themes/YOUR_THEME_NAME.scss
```

2. edit `./themes/YOUR_THEME_NAME.scss`

3. build polyca.scss

```sh
$ yarn build
```

4. test in index.html

class name: `.theme-YOUR_THEME_NAME`

```html
<head>
  <link rel="stylesheet" href="dist/polyca.min.css">
</head>
<body class="theme-YOUR_THEME_NAME">
</body>
```

