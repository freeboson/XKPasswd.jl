module xkpasswd

#datapath = joinpath(@__DIR__, "..", "data")
datapath = joinpath(dirname(@__FILE__), "..", "data")
google10kpath = joinpath(datapath, "google-10000-english")

pwentropy(n, total, digit) = n*log2(total) + (digit ? log2(10) : 0)

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
                  append_digit::Bool=true)
    @assert n > 0 "Must use at least 1 random word"
    @assert npws > 0 "Must generate at least 1 password"
    open(wordlist) do f
#        lines = readlines(f, chomp=true)
        lines = readlines(f);
        println(STDERR, "Estimated entropy: ",
                "~$(round(Int, pwentropy(n,length(lines),append_digit))) bits.")
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
                  append_digit::Bool=true)
    generate(n, wordlistfiles[wordlist], npws=npws, capitalize=capitalize,
             delimstr=delimstr, append_digit=append_digit)
end

end # module

