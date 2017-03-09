module xkpasswd

pwentropy(n, total, digit) = n*log2(total) + (digit ? log2(10) : 0)

function generate(n::Integer; npws::Integer=1, capitalize::Bool=false, wordlist::AbstractString="google-10000-english-usa-no-swears.txt", delimstr::AbstractString=" ", append_digit::Bool=true)
    @assert n > 0 "Must use at least 1 random word"
    @assert npws > 0 "Must generate at least 1 password"
    open(wordlist) do f
        lines = readlines(f)
        println(STDERR, "Estimated entropy: ~$(pwentropy(n,length(lines),append_digit) |> round |> Int) bits.")
        [(
            words = map(chomp, rand(lines, n));
            cased_words = capitalize ?  map(ucfirst, words) : words;
            string(join(cased_words, delimstr), 
                   append_digit ? "$(delimstr)$(rand(0:9))" : "")
         ) for k in 1:npws]
    end
end

end # module
