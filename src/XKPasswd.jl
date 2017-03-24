module XKPasswd

"""
`XKPasswd` generates memorable passwords for you in the style of diceware and
[xkcd #936](https://xkcd.com/936/).

This module does not export symbols but the main functions of interest are:

- `XKPasswd.generate`: gives an array of generated passwords
- `XKPasswd.pwentropy`: gives the bits of entropy in the password, with
  knowledge of the wordlist used and formatting
- `XKPasswd.pw100yattrate`: estimates the guess attempt rate needed to brute
  force the password within 100 years, with knowledge of the wordlist used and
  formatting
- `XKPasswd.spin_the_wheel`: cycles through random passwords until you stop it
  (should be used from REPL or a terminal)

!!! warning

    Diceware fairly explicitly tells you to use dice for randomness and *not* a
    PRNG, so keep that in mind. (Do you know where your entropy comes from?)
"""
XKPasswd

using Base.prettyprint_getunits

const superunits = ["", " k", " M", " G", " T", " P", " E", " Z", " Y"]
const secper100y = 3.154e9

datapath = joinpath(dirname(@__FILE__), "..", "data")
google10kpath = joinpath(datapath, "google-10000-english")

pwentropy(n, total, digit) = n*log2(total) + (digit ? log2(10) : 0)
pw100yattrate(s) = BigFloat(2)^s / secper100y

function pw100yattrate_pretty(s::Real)::AbstractString
    rate = pw100yattrate(s)
    if rate < 1
        @sprintf("%.1E", s)
    else
        (atts, unit) = prettyprint_getunits(rate, length(superunits), 1000)
        string(round(BigInt, atts), superunits[unit])
    end
end

@enum WordList simple jargon google_20k google_10k google_10k_clean google_10k_usa google_10k_usa_clean google_10k_usa_clean_short google_10k_usa_clean_medium google_10k_usa_clean_long

wordlistfiles = Dict(simple => joinpath(datapath, "simple.txt"),
                     jargon => joinpath(datapath, "jargon.txt"),
                     google_20k => joinpath(google10kpath, "20k.txt"),
                     google_10k => joinpath(google10kpath,
                                            "google-10000-english.txt"),
                     google_10k_clean => joinpath(google10kpath,
                         "google-10000-english-no-swears.txt"),
                     google_10k_usa => joinpath(google10kpath,
                         "google-10000-english-usa.txt"),
                     google_10k_usa_clean => joinpath(google10kpath,
                         "google-10000-english-usa-no-swears.txt"),
                     google_10k_usa_clean_short => joinpath(google10kpath,
                         "google-10000-english-usa-no-swears-short.txt"),
                     google_10k_usa_clean_medium => joinpath(google10kpath,
                         "google-10000-english-usa-no-swears-medium.txt"),
                     google_10k_usa_clean_long => joinpath(google10kpath,
                         "google-10000-english-usa-no-swears-long.txt"))

function stats(n, l, d)::AbstractString
    s = pwentropy(n, l, d)
    string("Entropy: ~", round(Int, s), " bits; 100y BF attempt rate: ",
           pw100yattrate_pretty(s), " att/s.")
end

"""
    XKPasswd.generate(n[, wordlist=XKPasswd.simple]; <keyword arguments>)

Generate an array of memorable passwords of a given specification.

# Arguments
* `n::Integer`: the number of random words per password
* `wordlist::WordList=XKPasswd.simple`: selection from the bundled word list options OR
* `wordlist::AbstractString`: the path to a newline delimited word list file
* `npws::integer=1`: the number of passwords to generate
* `captialize::Bool=false`: whether to capitalize the first letter of each word
* `delimstr::AbstractString=" "`: what to insert between each word
* `append_digit::Bool=true`: whether to tack on a single digit at the end
* `quiet::Bool=false`: whether to print entropy information to STDERR

# Examples

```julia
julia> XKPasswd.generate(4, append_digit=false) # output here is just a joke
Entropy: ~45 bits; 100y BF attempt rate: 9 k att/s.
1-element Array{String,1}:
 "correct horse battery staple"
```
"""
function generate(n::Integer, wordlist::AbstractString; npws::Integer=1,
                  capitalize::Bool=false, delimstr::AbstractString=" ",
                  append_digit::Bool=true, quiet::Bool=false)
    @assert n > 0 "Must use at least 1 random word"
    @assert npws > 0 "Must generate at least 1 password"
    open(wordlist) do f
#        lines = readlines(f, chomp=true)
        lines = readlines(f);

        if (!quiet)
            println(STDERR, stats(n, length(lines), append_digit))
        end

        [(
#            words = rand(lines, n);
            words = map(chomp, rand(lines, n));
            cased_words = capitalize ?  map(ucfirst, words) : words;
            string(join(cased_words, delimstr),
                   append_digit ? "$(delimstr)$(rand(0:9))" : "")
         ) for k in 1:npws]
    end
end

function generate(n::Integer, wordlist::WordList=simple; npws::Integer=1,
                  capitalize::Bool=false, delimstr::AbstractString=" ",
                  append_digit::Bool=true, quiet::Bool=false)
    generate(n, wordlistfiles[wordlist], npws=npws, capitalize=capitalize,
             delimstr=delimstr, append_digit=append_digit, quiet=quiet)
end

"""
    XKPasswd.spin_the_wheel(n::Integer=4[, wordlist=XKPasswd.simple]; <keyword arguments>)

Starts cycling through randomly generated passwords, selecting the last one once
you hit [Enter] on your keyboard. Arguments are the same as in
[`XKPasswd.generate`](@ref), though without `npws` and `quiet`.

!!! note

    This function puts VT100 commands to `STDOUT` and reads from file descriptor
    `0`, so it might not be applicable in all situations.
"""
function spin_the_wheel(n::Integer, wordlist::AbstractString;
                        capitalize::Bool=false, delimstr::AbstractString=" ",
                        append_digit::Bool=true)
    println(STDERR, stats(n, length(lines), append_digit))
    println("Spinning... Press [enter] to end\n\n")
    while true
        ev = poll_fd(RawFD(0), 0, readable=true)
        p = rand(XKPasswd.generate(n, npws=20, quiet=true,
                                   capitalize=capitalize, delimstr=delimstr,
                                   append_digit=append_digit))
        print("\u1b[1A\u1b[K\u1b[1K")
        println(p)
        if ev.readable
            print("\u1b[1A\u1b[K\u1b[1K")
            break
        end
    end
end

function spin_the_wheel(n::Integer=4, wordlist::WordList=simple;
                        capitalize::Bool=false, delimstr::AbstractString=" ",
                        append_digit::Bool=true)
    spin_the_wheel(n, wordlistfiles[wordlist], capitalize=capitalize,
                   delimstr=delimstr, append_digit=append_digit)
end

end # module

