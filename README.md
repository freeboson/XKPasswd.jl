[![Build Status](https://travis-ci.org/freeboson/xkpasswd.jl.svg?branch=master)](https://travis-ci.org/freeboson/xkpasswd.jl)

[![Coverage Status](https://coveralls.io/repos/freeboson/xkpasswd.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/freeboson/xkpasswd.jl?branch=master)

[![codecov.io](http://codecov.io/github/freeboson/xkpasswd.jl/coverage.svg?branch=master)](http://codecov.io/github/freeboson/xkpasswd.jl?branch=master)

```
                    _                                    _    _ _ 
              __  _| | ___ __   __ _ ___ _____      ____| |  (_) |
              \ \/ / |/ / '_ \ / _` / __/ __\ \ /\ / / _` |  | | |
               >  <|   <| |_) | (_| \__ \__ \\ V  V / (_| |_ | | |
              /_/\_\_|\_\ .__/ \__,_|___/___/ \_/\_/ \__,_(_)/ |_|
                        |_|                                |__/   
```

This is a password generator written in [Julia](https://julialang.org), inspired
by [XKCD #963](https://xkcd.com/936/). The default word list is provided (as a
git submodule) by [this
repository](https://github.com/first20hours/google-10000-english), but you can
use whatever word list you want.

Quickstart
----------

Running this is trivial why Julia's package manager:

```jlcon
julia> Pkg.add("xkpasswd")
julia> using xkpasswd;
julia> xkpasswd.generate(4)
```

Don't use any of the above as your own password :)

