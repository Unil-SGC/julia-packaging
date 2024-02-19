#src # This is needed to make this run as normal Julia file
using Markdown #src

#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
# Julia packaging

<br>
</br>

<center><img src="assets/Julia_logo.png" width="300" style="border:0">
        <img src="assets/Pkg_logo.png" width="200" style="border:0" \n\n></center>

<br>
</br>

<center> Ludovic Räss - University of Lausanne </center>
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Contents

1. Why and when to create a Julia package

2. From Julia Jupyter Notebooks to Julia scripts

3. From Julia script to Julia package
    - Difference between scritps, package (with/out modules)
    - Julia project files structure
        - `.toml` files, structure

4. Share your package
    - Publish your package on GitHub
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Prior to package your code

1. Does it make sense to package your code?
2. Is your code high quality enough?
3. Should data be included or accessible out of the code?
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
### Prerequisites

You must have:
1. [Julia (Juliaup)](https://github.com/JuliaLang/juliaup), [VSCode](https://code.visualstudio.com/) and Julialang VSCode extension installed on your laptop (see the main repo README for _how-to_)

2. An account on [GitHub](https://github.com)
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## From Julia Jupyter notebooks to Julia scripts

1. What criticisms can you make on [this ice flow visualization code (visualize_iceflow_1.ipynb)](visualize_iceflow_1.ipynb)?
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## From Julia Jupyter notebooks to Julia scripts

1. What criticisms can you make on [this ice flow visualization code](visualize_iceflow_1.ipynb)?
    - variables name,
    - split into functions,
    - syntax considerations,
    - comments & documentation,
    - avoid code not adapted to all OS (path example),

    → Code after improvement [here (visualize_iceflow_2.ipynb)](visualize_iceflow_2.ipynb)
"""

#nb # %% A slide [markdown] {"slideshow": {"slide_type": "fragment"}}
md"""
2. Split into functions/structures

    → Code after improvement [here (visualize_iceflow_3.ipynb)](visualize_iceflow_3.ipynb)
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## From Julia Jupyter Notebooks to Julia scripts

3. Create a Julia script from the Julia jupyter notebook
    - `jupyter nbconvert --to script visualize_iceflow_3.ipynb`
    - → code [here](visualize_iceflow_3.jl)
<br>
</br>
4. Clean Julia script
    - use one of the Julia formatters
        - [JuliaFormatter](https://domluna.github.io/JuliaFormatter.jl/stable/) (from [within VSCode](https://www.julia-vscode.org/docs/stable/userguide/formatter/))
    - take care about style, variable names, alignment, etc...
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## From Julia script to Julia package

- Difference between scritps, package (with/out modules)
- Julia project files: `.toml`
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Step 1: Create your package structure using [`PkgTemplates.jl`](https://juliaci.github.io/PkgTemplates.jl/stable/)

- Choose a package name, here `IceFlow.jl`

Using [`PkgTemplates.jl`](https://juliaci.github.io/PkgTemplates.jl/stable/):
"""
julia> using Pkg; Pkg.add("PkgTemplates")

md"""
Interactive Generation:
"""
using PkgTemplates
Template(interactive=true)("IceFlow.jl")

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
Set `user`, `dir` and `host`:
"""

julia> Template(interactive=true)("IceFlow.jl")
Template keywords to customize:
[press: Enter=toggle, a=all, n=none, d=done, q=abort]
 > [X] user ("")
   [ ] authors ("Ludovic Raess <ludovic.rass@gmail.com> and contributors")
   [X] dir ("~/.julia/dev")
   [X] host ("github.com")
   [ ] julia (v"1.0.0")
   [ ] plugins (PkgTemplates.Plugin[])

md"""
After pressing `d`, you will be able to provide a value for those setting.

⚠ `user` should match your GitHub username!
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
Let's examine what file and directory structure we created:
- `src` and `test` dirs
- README and LICENSE
- `.toml` files
- `.git`, `.gitignore` and `.github` "hidden" files

💡 Delete the `.github` file (or rename it) if you don't want to enable CI/CD on GitHub Actions.
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Step 2: Split the Julia script into modules

- Make judicious choices: functions exclusively used in the package versus functions exposed to users.

→ Let's have a look at the proposed package structure for `IceFlow.jl` in the provided package draft [`../IceFlow.jl`](../IceFlow.jl)
"""

#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
Structure:
    - specific files for data, solver and utilities
    - main IceFlow module
    - export functions, include files, define package-wide `const`
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Step 3: Documentation and Tests

### Documentation:
- In-code documentation
    - Docstrings
    - functions, modules, code
    - Can be accessed from REPL `?`

- Package documentation
    - README
    - How to use the package
    - Advanced: using [Documenter.jl](https://documenter.juliadocs.org/stable/) to create online doc (read-the-doc style)
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
### Tests:

Julia offers great native testing framework:
- `test` folder with dedicated `Project.toml`
- `runtests.jl` file to include `@test` grouped in `@testset`
- Can be executed from the REPL locally: `using Pkg; Pkg.test()`
- Advanced: Can be executed in CI/CD pipelines
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Step 4: Project files

- Review and complete the `Project.toml` file
- Make sure to add `Manifest.toml` (and `.DS_Store` for macOS users) to the `.gitignore`
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Step 5: Publish your package on GitHub

1. Create a new GitHub repository with the exact same name of your package: `IceFlow.jl`
2. Locally, in the root of your package directory: `git add remote add origin <address of the new repository>`
3. Push code on remote GitHub server: `git push -u origin main`
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Step 6: (Advanced) register your package in the Julia Registry

Upon doing so and passing the checks, IceFlow.jl could then be installed by anyone upon typing

```julia-repl
julia> ]

(@v1.10) pkg> add IceFlow
```

More infos here [https://julialang.org/contribute/developing_package/#step_5_register_your_package](https://julialang.org/contribute/developing_package/#step_5_register_your_package)
"""

#src #########################################################################
#nb # %% A slide [markdown] {"slideshow": {"slide_type": "slide"}}
md"""
## Any questions?

<br>
</br>
<br>
</br>

<center><img src="assets/SGC_unilogo_bleu_300dpi.png" width="250" style="border:0"></center>

<br>
</br>
<br>
</br>

<center>Swiss Geocomputing Centre</center>

"""
