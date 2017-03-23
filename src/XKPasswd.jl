module XKPasswd

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

function generate(n::Integer, wordlist::AbstractString; npws::Integer=1,
                  capitalize::Bool=false, delimstr::AbstractString=" ",
                  append_digit::Bool=true, quiet::Bool=false)
    @assert n > 0 "Must use at least 1 random word"
    @assert npws > 0 "Must generate at least 1 password"
    open(wordlist) do f
#        lines = readlines(f, chomp=true)
        lines = readlines(f);

        if (!quiet)
            s = pwentropy(n, length(lines), append_digit)
            println(STDERR, "Entropy: ~", round(Int, s), " bits; ",
                    "100y BF attempt rate: ", pw100yattrate_pretty(s),
                    " att/s.")
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
                  append_digit::Bool=true, quiet::Bool=true)
    generate(n, wordlistfiles[wordlist], npws=npws, capitalize=capitalize,
             delimstr=delimstr, append_digit=append_digit, quiet=quiet)
end

function spin_the_wheel(n::Integer=4, wordlist::WordList=simple;
                        capitalize::Bool=false, delimstr::AbstractString=" ",
                        append_digit::Bool=true)
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

end # module

