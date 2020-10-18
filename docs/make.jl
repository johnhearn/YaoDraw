push!(LOAD_PATH,"../src/")

using Documenter
using YaoDraw

makedocs(
    modules = [YaoDraw],
    doctest = true,
    sitename = "YaoDraw.jl",
    pages = ["index.md", 
             "todo.md",
             "api.md", 
             "examples.md"],
    format = Documenter.HTML(prettyurls = false)
)