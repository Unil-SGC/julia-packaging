# Julia-packaging

<img src="material/assets/SGC_unilogo_bleu_300dpi.png" alt="ParallelStencil.jl" width="200">  **[Packaging workshop](https://unil-sgc.github.io/events/pkg-workshop/) - Swiss Gecomputing Centre & DCSR, UNIL.**

<br>

:bulb: The Python packaging material for the morning session can be accessed here: [python-packaging](https://github.com/MargotSirdey/python-packaging)

## Content

This repository contains the [initial notebooks](material/) we will discuss throughout the afternoon session of the packaging workshop, as well as the packages and module-based refactored script [IceFlow.jl](IceFlow.jl/) we want to achieve and host on a separate GitHub repository.
- [material](material/)
    - [visualize_iceflow_1.ipynb](material/visualize_iceflow_1.ipynb): the usual "draft" WIP script (monolithic, no functions, no documentation).
    - [visualize_iceflow_2.ipynb](material/visualize_iceflow_2.ipynb): the re-arranged script wit some documentation, functions.
    - [visualize_iceflow_3.ipynb](material/visualize_iceflow_3.ipynb): the script using a structure to hold the data and grid information, with docstrings.
    - [iceflow.jl](material/iceflow.jl): the plain Julia script relating the the [visualize_iceflow_3.ipynb](material/visualize_iceflow_3.ipynb) we will use to split into modules and package.

- [IceFlow.jl](IceFlow.jl/): The Julia package we will create from the monolithic Julia script [iceflow.jl](material/iceflow.jl).

- :book: The slides are available at [material/packaging_julia.ipynb](material/packaging_julia.ipynb) and can be run as a Jupyter notebook (+ RISE plugin for slideshow).

### Final IceFlow.jl package

The fully packaged and standalone version of IceFlow.jl can be accessed at [https://github.com/Unil-SGC/IceFlow.jl](https://github.com/Unil-SGC/IceFlow.jl) and installed in Julia as following:
```julia-repl
using Pkg; Pkg.add("https://github.com/Unil-SGC/IceFlow.jl")
```

# Getting started - Installing Julia and VScode

This guide provides step-by-step instructions for installing Julia via Juliaup and setting up Visual Studio Code (VSCode) for Julia development.

## Prerequisites

- Basic familiarity with command-line operations.
- Internet connection for downloading necessary software.

## Step 1: Install Juliaup

[Juliaup](https://github.com/JuliaLang/juliaup) is a Julia version manager that simplifies the process of installing Julia and managing multiple Julia versions.

### Windows

1. Open the Windows Terminal or Command Prompt.
2. Run the following command:

   ```bash
   winget install julia
   ```

### macOS and Linux

1. Open the Terminal.
2. Install Juliaup using the following command:

   ```bash
   curl -fsSL https://install.julialang.org | sh
   ```

## Step 2: Install Julia

Once Juliaup is installed, you can easily install Julia.

1. In the Terminal or Command Prompt, run:

   ```bash
   juliaup add latest
   ```

2. This command installs the latest stable version of Julia.

For more information on using Juliaup, refer to the [Juliaup documentation](https://github.com/JuliaLang/juliaup).

## Step 3: Install Visual Studio Code (VSCode)

VSCode is a popular code editor that supports Julia through extensions.

1. Download VSCode from [Visual Studio Code official website](https://code.visualstudio.com/).
2. Follow the installation instructions for your operating system.

## Step 4: Install the Julia Extension in VSCode

To integrate Julia with VSCode, you need to install the Julia extension.

1. Open VSCode.
2. Go to the Extensions view by clicking on the square icon on the sidebar, or press `Ctrl+Shift+X`.
3. Search for "Julia" in the extensions marketplace.
4. Click on the "Install" button for the Julia extension provided by 'julialang'.

## Step 5: Configure the Julia Extension (Optional)

To ensure that VSCode uses the correct Julia version, you can specify the Julia binary path.

1. In VSCode, go to File > Preferences > Settings (or `Ctrl+,`).
2. Search for "Julia: Executable Path".
3. Enter the path to the Julia executable. (Typically, Juliaup sets this up automatically.)

## Conclusion

You're all set! You can now start developing Julia projects in VSCode. Open a new file with a `.jl` extension and begin coding in Julia.

For more information on using Julia with VSCode, refer to the [VSCode Julia extension documentation](https://www.julia-vscode.org/docs/stable/).
